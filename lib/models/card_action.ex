defmodule ExMicrosoftBot.Models.CardAction do
  @moduledoc """
  Microsoft bot card action structure
  """

  @derive [Poison.Encoder]
  defstruct [:type, :title, :value]

  @type t :: %ExMicrosoftBot.Models.CardAction{
    type: String.t,
    title: String.t,
    value: String.t
  }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.CardAction{}
  end
end
