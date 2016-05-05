defmodule MicrosoftBot.Models.ChannelAccount do
  @moduledoc """
  Microsoft bot channel account structure which corresponde to a user or bot
  """

  @derive [Poison.Encoder]
  defstruct [
    :name, :channelId, :address, :id, :isBot
  ]

  @type t :: %MicrosoftBot.Models.ChannelAccount{
    name: String.t, channelId: String.t, address: String.t, id: String.t,
    id: String.t, isBot: boolean
  }

  @doc false
  def decoding_map do
    %MicrosoftBot.Models.ChannelAccount{}
  end
end
