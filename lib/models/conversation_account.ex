defmodule ExMicrosoftBot.Models.ConversationAccount do
  @moduledoc """
  Microsoft bot conversation account structure
  """

  @derive [Poison.Encoder]
  defstruct [:isGroup, :id, :name]

  @type t :: %ExMicrosoftBot.Models.ConversationAccount{
    isGroup: boolean,
    id: String.t,
    name: String.t
  }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.ConversationAccount{}
  end
end
