defmodule ExMicrosoftBot.Client do
  @moduledoc """
  Use the Microsoft bot framework to create bots for multiple different platforms.
  """

  require Logger

  @type error_type :: {:error, integer, String.t()}

  def deserialize_response(%HTTPotion.Response{status_code: 200, body: ""}, _deserialize_fn) do
    {:ok, ""}
  end

  def deserialize_response(%HTTPotion.Response{status_code: 200, body: body}, deserialize_fn) do
    {:ok, deserialize_fn.(body)}
  end

  def deserialize_response(
        %HTTPotion.Response{status_code: status_code, body: body} = response,
        _deserialize_fn
      ) do
    Logger.error("Error response: #{status_code}: #{body} \n Raw Response: #{inspect(response)}")
    {:error, status_code, body}
  end

  def deserialize_response(%HTTPotion.ErrorResponse{message: message} = resp, _deserialize_fn) do
    Logger.error("deserialize_response/2: Error response: #{message}")
    Logger.error("deserialize_response/2: Error response: #{inspect(resp)}")
    {:error, 0, message}
  end

  def headers(token, uri) do
    Keyword.merge(
      [
        "Content-Type": "application/json",
        Accept: "application/json"
      ],
      create_auth_headers(token, uri)
    )
  end

  # Private

  defp create_auth_headers(token, uri) do
    uri
    |> is_https()
    |> auth_headers(token)
  end

  defp is_https(uri) do
    %URI{scheme: scheme} = URI.parse(uri)
    scheme == "https"
  end

  defp auth_headers(is_https, auth_data) do
    auth_headers(is_https, auth_data, Application.get_env(:ex_microsoftbot, :using_bot_emulator))
  end

  defp auth_headers(false = _is_https, _auth_data, true) do
    [
      Authorization: "Bearer"
    ]
  end

  defp auth_headers(true = _is_https, token, _) do
    [
      Authorization: "Bearer #{token}"
    ]
  end
end
