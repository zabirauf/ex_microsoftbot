defmodule ExMicrosoftBot.Models.Entity do
  @moduledoc """
  Microsoft bot entity structure
  """

  @derive [Poison.Encoder]
  defstruct [:type, :name, :supportsDisplay]

  @type t :: %ExMicrosoftBot.Models.Entity{
    type: String.t,
    name: String.t,
    supportsDisplay: boolean,
  }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.Entity{}
  end
end
