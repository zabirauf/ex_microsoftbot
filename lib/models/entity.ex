defmodule ExMicrosoftBot.Models.Entity do
  @moduledoc """
  Microsoft bot entity structure
  """

  @derive [Poison.Encoder]
  defstruct [:type]

  @type t :: %ExMicrosoftBot.Models.Entity{
    type: String.t
  }

  @doc false
  def decoding_map do
    %ExMicrosoftBot.Models.Entity{}
  end
end
