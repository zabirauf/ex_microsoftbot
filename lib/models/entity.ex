defmodule ExMicrosoftBot.Models.Entity do
  @moduledoc """
  Microsoft bot entity structure
  """

  @derive [Poison.Encoder]
  defstruct [:type, :name]

  @type t :: %ExMicrosoftBot.Models.Entity{
    type: String.t,
    name: String.t
  }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.Entity{}
  end
end
