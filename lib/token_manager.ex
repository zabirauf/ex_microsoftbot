defmodule ExMicrosoftBot.TokenManager do
  @moduledoc """
  This module is a GenServer that handles getting access token from
  Microsoft bot framework and also is responsible for refreshing the token
  before it expires.
  """

  use ExMicrosoftBot.RefreshableAgent
  alias ExMicrosoftBot.{Client, Models}

  @auth_api_endpoint "https://login.microsoftonline.com/botframework.com/oauth2/v2.0/token"
  @scope "https://api.botframework.com/.default"

  # Public API

  @doc """
  Get the token that can be used to authorize calls to Microsoft Bot Framework
  """
  def get_token() do
    case get_state() do
      {:ok, %{token: token}} -> token
      _ -> nil
    end
  end

  # Refreshable Agent Callbacks

  @time_gap_to_refresh_in_seconds 500
  @time_to_refresh_on_error_in_seconds 15

  @doc """
  Refresh the token by making a service call and then scheduling a message to
  this GenServer before token expires so that it can be refreshed
  """
  def get_refreshed_state(%Models.AuthData{} = auth_data, _old_state) do
    :ex_microsoftbot
    |> Application.get_env(:using_bot_emulator)
    |> do_get_refreshed_state(auth_data)
  end

  @doc """
  The time to refresh which is taken from the response of the token
  """
  def time_to_refresh_after_in_seconds({:ok, %{expiry_in_seconds: expiry_in_seconds}}) do
    expiry_in_seconds - @time_gap_to_refresh_in_seconds
  end

  def time_to_refresh_after_in_seconds({:error, _, _}) do
    @time_to_refresh_on_error_in_seconds
  end

  # Private

  defp do_get_refreshed_state(_emulator? = true, %Models.AuthData{} = _auth_data) do
    {:ok, %{token: "TestToken", expiry_in_seconds: 36000}}
  end

  defp do_get_refreshed_state(__emulator?, %Models.AuthData{} = auth_data) do
    auth_data
    |> refresh_token()
    |> validate_token()
  end

  defp validate_token({:ok, %{token: token} = token_response}) do
    # TODO: See what other checks are needed to verify the JWT
    with jwt <- JOSE.JWT.peek_payload(token),
         true <- contains_valid_app_id_claim?(jwt) do
      {:ok, token_response}
    else
      result ->
        Logger.error("Error validating token. Result: #{inspect(result)}")
        {:error, result}
    end
  end

  defp validate_token({:error, _status_code, _body} = error) do
    Logger.error("Error validating token. Result: #{inspect(error)}")
    error
  end

  defp contains_valid_app_id_claim?(%JOSE.JWT{} = jwt) do
    contains_valid_app_id_claim?(Application.get_env(:ex_microsoftbot, :app_id), jwt)
  end

  defp contains_valid_app_id_claim?(expected_app_id, %JOSE.JWT{
         fields: %{"appid" => expected_app_id}
       }),
       do: true

  defp contains_valid_app_id_claim?(_, %JOSE.JWT{}), do: false

  defp refresh_token(%Models.AuthData{} = auth_data) do
    case get_token_from_service(auth_data) do
      {:ok, token_response} ->
        {:ok,
         %{
           token: Map.get(token_response, "access_token"),
           expiry_in_seconds: Map.get(token_response, "expires_in")
         }}

      {:error, _status_code, _body} = error ->
        Logger.error("Error refreshing token. Result: #{inspect(error)}")
        error
    end
  end

  defp get_token_from_service(%Models.AuthData{app_id: app_id, app_password: app_password}) do
    auth_api_endpoint =
      Application.get_env(:ex_microsoftbot, :auth_api_endpoint) || @auth_api_endpoint

    scope = Application.get_env(:ex_microsoftbot, :scope) || @scope

    body =
      convert_to_post_params_string(
        # In testing the first param was not detected by the API hence adding a dummy param
        dummy_param: "dummy",
        grant_type: "client_credentials",
        client_id: app_id,
        client_secret: app_password,
        scope: scope
      )

    auth_api_endpoint
    |> HTTPotion.post(body: body)
    |> Client.deserialize_response(&Poison.decode!(&1, as: %{}))
  end

  defp convert_to_post_params_string(params) do
    params
    |> Enum.reduce([], fn {k, v}, acc -> ["#{k}=#{URI.encode_www_form(v)}" | acc] end)
    |> Enum.reverse()
    |> Enum.join("&")
  end
end
