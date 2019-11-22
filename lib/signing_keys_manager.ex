defmodule ExMicrosoftBot.SigningKeysManager do
  use ExMicrosoftBot.RefreshableAgent

  import ExMicrosoftBot.Client, only: [req_options: 0, deserialize_response: 2]

  # Public API

  @doc """
  Get the token that can be used to authorize calls to Microsoft Bot Framework
  """
  def get_keys() do
    get_state()
  end

  def force_refresh_keys() do
    force_refresh_state()
  end

  # Refreshable Agent Callbacks

  def get_refreshed_state(_args, _old_state) do
    get_microsoft_bot_keys()
  end

  def time_to_refresh_after_in_seconds(_state) do
    # 5 Days to expire the signing keys
    # Round to_seconds to return in scientific notation
    5
    |> Timex.Duration.from_days()
    |> Timex.Duration.to_seconds()
    |> Kernel.round()
  end

  # Private

  defp get_microsoft_bot_keys() do
    with {:ok, %{"jwks_uri" => uri}} <- get_json_from_wellknown_key_uri(),
         {:ok, %{"keys" => keys}} <- get_json_from_uri(uri) do
      {:ok, Enum.map(keys, &JOSE.JWK.from_map/1)}
    else
      {:error, _, _} = error -> error
    end
  end

  defp get_json_from_wellknown_key_uri() do
    :ex_microsoftbot
    |> Application.get_env(:openid_valid_keys_url)
    |> get_json_from_uri()
  end

  defp get_json_from_uri(uri) do
    uri
    |> HTTPotion.get(req_options())
    |> deserialize_response(&Poison.decode!(&1, as: %{}))
  end
end
