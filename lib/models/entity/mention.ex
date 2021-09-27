defmodule ExMicrosoftBot.Models.Entity.Mention do
  @moduledoc """
  Mention entities have
  """

  @derive [Poison.Encoder]
  defstruct [:id, :name]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t()
        }

  @doc false
  def decoding_map do
    %__MODULE__{}
  end
end
