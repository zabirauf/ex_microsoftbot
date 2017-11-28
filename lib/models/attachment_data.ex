defmodule ExMicrosoftBot.Models.AttachmentData do
  @moduledoc """
  Microsoft bot attachment structure within the message
  """

  @derive [Poison.Encoder]
  defstruct [:type, :name, :originalBase64, :thumbnailBase64]

  @type t :: %ExMicrosoftBot.Models.AttachmentData {
    type: String.t,
    name: String.t,
    originalBase64: String.t,
    thumbnailBase64: String.t
  }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.AttachmentData {}
  end
end
