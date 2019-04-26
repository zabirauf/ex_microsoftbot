defmodule ExMicrosoftBot.Models.ChannelAccount do
  @moduledoc """
  Microsoft bot channel account structure which corresponde to a user or bot
  """

  @derive [Poison.Encoder]
  defstruct [:id, :name]

  @type t :: %ExMicrosoftBot.Models.ChannelAccount{
    id: String.t,
    name: String.t
  }

  @doc """
  Decode a map into `ExMicrosoftBot.Models.ChannelAccount`
  """
  @spec parse(map) :: {:ok, ExMicrosoftBot.Models.ChannelAccount.t}
  def parse(param) when is_map(param) do
    Poison.Decode.decode(param, as: decoding_map())
  end

  @doc """
  Decode a list of maps into a list of `ExMicrosoftBot.Models.ChannelAccount`
  """
  @spec parse(list) :: {:ok, [ExMicrosoftBot.Models.ChannelAccount.t]}
  def parse(param) when is_list(param) do
    Poison.Decode.decode(param, as: [decoding_map()])
  end

  @doc """
  Decode a string into `ExMicrosoftBot.Models.ChannelAccount`
  """
  @spec parse(String.t) :: ExMicrosoftBot.Models.ChannelAccount.t
  def parse(param) when is_binary(param) do
    parse Poison.decode!(param)
  end

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.ChannelAccount{}
  end
end
