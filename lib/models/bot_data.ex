defmodule MicrosoftBot.Models.BotData do
  @moduledoc """
  Microsoft bot data structure
  """

  @derive [Poison.Encoder]
  defstruct [:data, :eTag]

  @type t :: %MicrosoftBot.Models.BotData {
    data: map,
    eTag: String.t
  }

  @doc """
  Decode a map into `MicrosoftBot.Models.BotData`
  """
  @spec parse(map) :: MicrosoftBot.Models.BotData.t
  def parse(param) when is_map(param) do
    Poision.Decode.decode(param, as: decoding_map)
  end

  @doc """
  Decode a string into `MicrosoftBot.Models.BotData`
  """
  @spec parse(String.t) :: MicrosoftBot.Models.BotData.t
  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map)
  end

  @doc false
  def decoding_map do
    %MicrosoftBot.Models.BotData{}
  end
end
