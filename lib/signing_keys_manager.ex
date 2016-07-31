defmodule ExMicrosoftBot.SigningKeysManager do
  require Logger
  use ExMicrosoftBot.RefreshableAgent

  alias ExMicrosoftBot.Client

  ################################################
  ##### Functions to interact with GenServer #####
  ################################################

  @doc """
  Get the token that can be used to authorize calls to Microsoft Bot Framework
  """
  def get_keys() do
    get_state()
  end

  #######################################
  ##### Refreshable Agent Callbacks #####
  #######################################

  def get_refreshed_state(_args, _old_state) do
    get_microsoft_bot_keys()
  end

  def time_to_refresh_after_in_seconds(_state) do
    # 5 Days to expire the signing keys
    Timex.Duration.from_days(5)
    |> Timex.Duration.to_seconds
  end

  ###############################
  ####### Helper functions ######
  ###############################


  defp get_microsoft_bot_keys() do
    %{"jwks_uri" => uri} = get_wellknown_key_uri()
    %{"keys" => keys}= get_json_from_uri(uri)

    keys
    |> Enum.map(fn (key) ->
      JOSE.JWK.from_map(key)
    end)
  end

  defp get_wellknown_key_uri() do
    "https://api.aps.skype.com/v1/.well-known/openidconfiguration"
    |> get_json_from_uri
  end

  defp get_json_from_uri(uri) do
    HTTPotion.get(uri)
    |> Client.deserialize_response(&(Poison.decode!(&1, as: %{})))
  end
end
