defmodule ExMicrosoftBot.Models.SuggestedAction do
  @moduledoc """
  Microsoft bot suggested action structure
  """

  @derive [Poison.Encoder]
  defstruct [:actions, :to]

  @type t :: %ExMicrosoftBot.Models.SuggestedAction{
    actions: [ExMicrosoftBot.Models.CardAction.t],
    to: String.t,
  }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.SuggestedAction{
      actions: [ExMicrosoftBot.Models.CardAction.decoding_map()]
    }
  end
end
