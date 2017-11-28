defmodule ExMicrosoftBot.Models.BotData do
  @moduledoc """
  Microsoft bot data structure
  """

  @derive [Poison.Encoder]
  defstruct [:data, :eTag]

  @type t :: %ExMicrosoftBot.Models.BotData {
    data: map,
    eTag: String.t
  }

  @doc """
  Decode a map into `ExMicrosoftBot.Models.BotData`
  """
  @spec parse(map) :: {:ok, ExMicrosoftBot.Models.BotData.t}
  def parse(param) when is_map(param) do
    {:ok, Poison.Decode.decode(param, as: decoding_map())}
  end

  @doc """
  Decode a string into `ExMicrosoftBot.Models.BotData`
  """
  @spec parse(String.t) :: ExMicrosoftBot.Models.BotData.t
  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map())
  end

  @doc """
  Encodes the `ExMicrosoftBot.Models.BotData` to json string
  """
  @spec serialize(ExMicrosoftBot.Models.BotData.t) :: String.t
  def serialize(%ExMicrosoftBot.Models.BotData{} = bot_data) do
    Poison.encode!(bot_data)
  end

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.BotData{
      "data": %{}
    }
  end
end
