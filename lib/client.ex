defmodule ExMicrosoftBot.Client do
  @moduledoc """
  This module contains low-level functions for interacting with the Bot
  Framework API.

  For most use-cases and a friendlier API, each of the individual endpoints'
  client modules should be used instead:

  * `ExMicrosoftBot.Client.Attachments`
  * `ExMicrosoftBot.Client.Conversations`
  * `ExMicrosoftBot.Client.Teams`

  Still, this module exports functions that can help perform arbitrary,
  pre-authorized API calls, for example for fetching assets or calling new
  endpoints that this library hasn't implemented yet.
  """

  alias ExMicrosoftBot.TokenManager

  require Logger

  @type error_type :: {:error, integer, String.t()}

  @http_client_opts Application.get_env(:ex_microsoftbot, :http_client_opts, [])

  @doc """
  GETs the given URI with an authorized request & standard options, logging the
  result.
  """
  @spec get(url :: String.t(), extra_opts :: keyword()) :: HTTPoison.Response.t()
  def get(url, extra_opts \\ []) do
    response = HTTPoison.get(url, authed_headers(url), opts(extra_opts))

    Logger.debug("GET #{inspect(url)}: #{inspect(response)}")

    response
  end

  @doc """
  DELETEs the given URI with an authorized request & standard options, logging
  the result.
  """
  @spec delete(url :: String.t(), extra_opts :: keyword()) :: HTTPoison.Response.t()
  def delete(url, extra_opts \\ []) do
    response = HTTPoison.delete(url, authed_headers(url), opts(extra_opts))

    Logger.debug("DELETE #{inspect(url)}: #{inspect(response)}")

    response
  end

  @doc """
  POSTs the given body to the given URI with an authorized request & standard
  options, logging the result.

  If a map, the body is JSON encoded before POSTing. Will raise if encoding
  fails.
  """
  @spec post(url :: String.t(), body :: String.t() | map(), extra_opts :: keyword()) ::
          HTTPoison.Response.t()
  def post(url, body, extra_opts \\ [])

  def post(url, body, extra_opts) when is_binary(body) do
    response = HTTPoison.post(url, body, authed_headers(url), opts(extra_opts))

    Logger.debug("POST #{inspect(url)}: #{inspect(response)}", body: body)

    response
  end

  def post(url, body, extra_opts) when is_map(body),
    do: post(url, Poison.encode!(body), extra_opts)

  @doc """
  PUTs the given body to the given URI with an authorized request & standard
  options, logging the result.

  If a map, the body is JSON encoded before PUTing. Will raise if encoding
  fails.
  """
  @spec put(url :: String.t(), body :: String.t() | map(), extra_opts :: keyword()) ::
          HTTPoison.Response.t()
  def put(url, body, extra_opts \\ [])

  def put(url, body, extra_opts) when is_binary(body) do
    response = HTTPoison.put(url, body, authed_headers(url), opts(extra_opts))

    Logger.debug("PUT #{inspect(url)}: #{inspect(response)}", body: body)

    response
  end

  def put(url, body, extra_opts) when is_map(body),
    do: put(url, Poison.encode!(body), extra_opts)

  @doc """
  Helper that deserializes a request response using the given deserializing
  function if the given `response` has a successful status. Otherwise, returns
  an error tuple instead.

  The deserializing function is skipped when there is no body; an empty string
  is returned instead.
  """
  @spec deserialize_response(response :: HTTPoison.Response.t(), (String.t() -> deserialized)) ::
          {:ok, deserialized | String.t()} | {:error, integer(), String.t()}
        when deserialized: any()

  def deserialize_response({:ok, %HTTPoison.Response{status_code: sc, body: ""}}, _deserialize_fn)
      when sc >= 200 and sc < 300 do
    {:ok, ""}
  end

  def deserialize_response(
        {:ok, %HTTPoison.Response{status_code: sc, body: body}},
        deserialize_fn
      )
      when sc >= 200 and sc < 300 do
    {:ok, deserialize_fn.(body)}
  end

  def deserialize_response(
        {:ok, %HTTPoison.Response{status_code: status_code, body: body} = response},
        _deserialize_fn
      ) do
    Logger.error("Error response: #{status_code}: #{body} \n Raw Response: #{inspect(response)}")
    {:error, status_code, body}
  end

  def deserialize_response({:error, %HTTPoison.Error{} = resp}, _deserialize_fn) do
    message = Exception.message(resp)
    Logger.error("deserialize_response/2: Error response: #{message}")
    Logger.error("deserialize_response/2: Error response: #{inspect(resp)}")
    {:error, 0, message}
  end

  @doc """
  Returns the headers required for an authorized JSON request to the
  BotFramework API.
  """
  @spec authed_headers(uri :: String.t()) :: [{String.t(), String.t()}]
  def authed_headers(uri) do
    Keyword.merge(
      [
        "Content-Type": "application/json",
        Accept: "application/json"
      ],
      create_auth_headers(uri)
    )
  end

  @doc """
  Returns an options Keyword for request functions. Merges the default options
  (from config) with the given `extra`.
  """
  @spec opts(keyword :: keyword()) :: keyword()
  def opts(extra \\ []),
    do: Keyword.merge(@http_client_opts, extra)

  # Private

  defp create_auth_headers(uri) do
    if !https?(uri) && using_emulator?() do
      [Authorization: "Bearer"]
    else
      [Authorization: "Bearer #{TokenManager.get_token()}"]
    end
  end

  defp https?(uri) do
    %URI{scheme: scheme} = URI.parse(uri)
    scheme == "https"
  end

  defp using_emulator?(),
    do: Application.get_env(:ex_microsoftbot, :using_bot_emulator)
end
