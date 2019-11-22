defmodule ExMicrosoftBot.Client do
  @moduledoc """
  Use the Microsoft bot framework to create bots for multiple different platforms.
  """

  require Logger

  alias ExMicrosoftBot.TokenManager

  @type error_type :: {:error, integer, String.t()}
  @http_timeout Application.get_env(:ex_microsoftbot, :http_timeout)

  def deserialize_response(%HTTPotion.Response{status_code: sc, body: ""}, _deserialize_fn) when sc >= 200 and sc < 300 do
    {:ok, ""}
  end

  def deserialize_response(%HTTPotion.Response{status_code: sc, body: body}, deserialize_fn) when sc >= 200 and sc < 300 do
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

  @doc """
  Returns an options Keyword with authorization headers set for making requests
  with HTTPotion.
  """
  @spec authed_req_options(String.t, keyword) :: keyword
  def authed_req_options(endpoint, extra \\ []) do
    [headers: headers(TokenManager.get_token(), endpoint)]
    |> Keyword.merge(extra)
    |> req_options()
  end

  @doc """
  Returns an options keyword with default config settings for HTTPotion merged
  with the given options.
  """
  @spec req_options(keyword) :: keyword
  def req_options(extra \\ []) do
    base_req_options()
    |> Keyword.merge(extra)
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

  defp base_req_options do
    case @http_timeout do
      nil -> []
      timeout -> [timeout: timeout]
    end
  end
end
