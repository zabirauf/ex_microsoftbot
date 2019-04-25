defmodule ExMicrosoftBot.Models.Activity do
  @moduledoc """
  Microsoft bot attachment structure for the activity sent to the conversation
  """

  @derive [Poison.Encoder]
  defstruct [
    :type, :id, :timestamp, :serviceUrl, :channelId, :from, :conversation, :recipient, :textFormat,
    :attachmentLayout, :membersAdded, :membersRemoved, :topicName, :historyDisclosed, :locale,
    :text, :speak, :summary, :attachments, :entities, :suggestedActions, :channelData, :action, :replyToId,
    :code, :inputHint
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
    speak: String.t,
    summary: String.t,
    attachments: [ExMicrosoftBot.Models.Attachment.t],
    entities: [ExMicrosoftBot.Models.Entity.t],
    suggestedActions: [ExMicrosoftBot.Models.SuggestedAction.t],
    channelData: map,
    action: String.t,
    inputHint: String.t,
    code: String.t,
    replyToId: String.t
  }

  @doc """
  Decode a map into `ExMicrosoftBot.Models.Activity`
  """
  @spec parse(map) :: {:ok, ExMicrosoftBot.Models.Activity.t}
  def parse(param) when is_map(param) do
    {:ok, Poison.Decode.decode(param, as: decoding_map())}
  end

  @doc """
  Decode a string into `ExMicrosoftBot.Models.Activity`
  """
  @spec parse(String.t) :: ExMicrosoftBot.Models.Activity.t
  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map())
  end

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.Activity {
      from: ExMicrosoftBot.Models.ChannelAccount.decoding_map(),
      conversation: ExMicrosoftBot.Models.ConversationAccount.decoding_map(),
      recipient: ExMicrosoftBot.Models.ChannelAccount.decoding_map(),
      membersAdded: [ExMicrosoftBot.Models.ChannelAccount.decoding_map()],
      membersRemoved: [ExMicrosoftBot.Models.ChannelAccount.decoding_map()],
      attachments: [ExMicrosoftBot.Models.Attachment.decoding_map()],
      entities: [ExMicrosoftBot.Models.Entity.decoding_map()],
      suggestedActions: [ExMicrosoftBot.Models.SuggestedAction.decoding_map()],
      channelData: %{}
    }
  end
end
