defmodule ExMicrosoftBot.Models.Attachment do
  @moduledoc """
  Microsoft bot attachment structure within the message
  """

  @derive [Poison.Encoder]
  defstruct [
    :contentType, :contentUrl, :content, :fallbackText, :title, :titleLink,
    :text, :thumbnailUrl, :actions
  ]

  @type t :: %ExMicrosoftBot.Models.Attachment{
    contentType: String.t, contentUrl: String.t, content: map, fallbackText: String.t,
    title: String.t, titleLink: String.t, text: String.t, thumbnailUrl: String.t,
    actions: [ExMicrosoftBot.Models.Action.t]
  }

  @doc false
  def decoding_map do
    %ExMicrosoftBot.Models.Attachment {
      "actions": [ExMicrosoftBot.Models.Action.decoding_map]
    }
  end
end
