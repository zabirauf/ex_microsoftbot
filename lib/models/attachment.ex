defmodule MicrosoftBot.Models.Attachment do
  @moduledoc """
  Microsoft bot attachment structure within the message
  """

  @derive [Poison.Encoder]
  defstruct [
    :contentType, :contentUrl, :content, :fallbackText, :title, :titleLink,
    :text, :thumbnailUrl, :actions
  ]

  @type t :: %MicrosoftBot.Models.Attachment{
    contentType: String.t, contentUrl: String.t, content: map, fallbackText: String.t,
    title: String.t, titleLink: String.t, text: String.t, thumbnailUrl: String.t,
    actions: [MicrosoftBot.Models.Action.t]
  }

  @doc false
  def decoding_map do
    %MicrosoftBot.Models.Attachment {
      "actions": [MicrosoftBot.Models.Action.decoding_map]
    }
  end
end
