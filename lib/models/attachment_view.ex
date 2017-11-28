defmodule ExMicrosoftBot.Models.AttachmentView do
  @moduledoc """
  Microsoft bot attachment view structure
  """

  @derive [Poison.Encoder]
  defstruct [:viewId, :size]

  @type t :: %ExMicrosoftBot.Models.AttachmentView{
    viewId: String.t,
    size: integer,
  }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.AttachmentView {}
  end
end
