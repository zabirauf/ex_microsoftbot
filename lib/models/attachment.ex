defmodule ExMicrosoftBot.Models.Attachment do
  @moduledoc """
  Microsoft bot attachment structure within the message
  """

  @derive [Poison.Encoder]
  defstruct [
    :contentType, :contentUrl, :content,
    :name, :thumbnailUrl
  ]

  @type t :: %ExMicrosoftBot.Models.Attachment{
    contentType: String.t,
    contentUrl: String.t,
    content: map,
    name: String.t,
    thumbnailUrl: String.t
  }

  @doc false
  def decoding_map do
    %ExMicrosoftBot.Models.Attachment {
      "content": %{}
    }
  end
end
