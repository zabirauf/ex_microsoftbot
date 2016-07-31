defmodule ExMicrosoftBot.Models.Activity do
  @moduledoc """
  Microsoft bot attachment structure for the activity sent to the conversation
  """

  @derive [Poison.Encoder]
  defstruct [
    :type, :id, :timestamp, :serviceUrl, :channelId, :from, :conversation, :recipient, :textFormat,
    :attachmentLayout, :membersAdded, :membersRemoved, :topicName, :historyDisclosed, :locale,
    :text, :summary, :attachments, :entities, :channelData, :action, :replyToId
  ]

  @type t :: %ExMicrosoftBot.Models.Activity{
    type: String.t,
    id: String.t,
    timestamp: String.t,
    serviceUrl: String.t,
    channelId: String.t,
    from: ExMicrosoftBot.Models.ChannelAccount.t,
    conversation: ExMicrosoftBot.Models.ConversationAccount.t,
    recipient: ExMicrosoftBot.Models.ChannelAccount.t,
    textFormat: String.t,
    attachmentLayout: String.t,
    membersAdded: [ExMicrosoftBot.Models.ChannelAccount.t],
    membersRemoved: [ExMicrosoftBot.Models.ChannelAccount.t],
    topicName: String.t,
    historyDisclosed: boolean,
    locale: String.t,
    text: String.t,
    summary: String.t,
    attachments: [ExMicrosoftBot.Models.Attachment.t],
    entities: [ExMicrosoftBot.Models.Entity.t],
    channelData: map,
    action: String.t,
    replyToId: String.t
  }

  @doc false
  def decoding_map do
    %ExMicrosoftBot.Models.Activity {
      "from": ExMicrosoftBot.Models.ChannelAccount.decoding_map,
      "conversation": ExMicrosoftBot.Models.ChannelAccount.decoding_map,
      "recipient": ExMicrosoftBot.Models.ChannelAccount.decoding_map,
      "membersAdded": [ExMicrosoftBot.Models.ChannelAccount.decoding_map],
      "membersRemoved": [ExMicrosoftBot.Models.ChannelAccount.decoding_map],
      "attachments": [ExMicrosoftBot.Models.Attachment.decoding_map],
      "entities": [ExMicrosoftBot.Models.Entity.decoding_map],
      "channelData": %{}
    }
  end
end