defmodule ExMicrosoftBot.Models.ResourceResponse do
  @moduledoc """
  Microsoft bot conversation API resource response
  """

  @derive [Poison.Encoder]
  defstruct [:id]

  @type t :: %ExMicrosoftBot.Models.ResourceResponse{
    id: String.t
  }

  @doc false
  def decoding_map do
    %ExMicrosoftBot.Models.ResourceResponse{}
  end
end
