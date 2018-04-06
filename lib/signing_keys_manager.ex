defmodule ExMicrosoftBot.SigningKeysManager do
  use ExMicrosoftBot.RefreshableAgent
  alias ExMicrosoftBot.Client

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
    %{"jwks_uri" => uri} = get_wellknown_key_uri()

    {:ok, %{"keys" => keys}} = get_json_from_uri(uri)

    Enum.map(keys, &JOSE.JWK.from_map/1)
  end

  defp get_wellknown_key_uri() do
    keys_url = Application.get_env(:ex_microsoftbot, :openid_valid_keys_url)

    {:ok, resp} = get_json_from_uri(keys_url)

    resp
  end

  defp get_json_from_uri(uri) do
    uri
    |> HTTPotion.get()
    |> Client.deserialize_response(&Poison.decode!(&1, as: %{}))
  end
end
