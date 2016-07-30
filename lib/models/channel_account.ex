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

  @doc false
  def decoding_map do
    %ExMicrosoftBot.Models.ChannelAccount{}
  end
end
