defmodule MicrosoftBot.Models.Message do
   @moduledoc """
   Microsoft bot message structure
   """

   @derive [Poison.Encoder]
   defstruct [
     :type, :id, :conversationId, :created, :sourceText, :sourceLanguage,
     :language, :text, :attachments, :from, :to, :replyToMessageId,
     :participants, :totalParticipants, :mentions, :place, :channelMessageId,
     :channelConversationId, :channelData, :botUserData, :botConversationData,
     :botPerUserInConversationData, :location, :hashtags, :eTag
   ]

   @type t :: %MicrosoftBot.Models.Message{
     type: String.t, id: String.t, conversationId: String.t, created: String.t,
     sourceText: String.t, sourceLanguage: String.t, language: String.t,
     text: String.t, attachments: [MicrosoftBot.Models.Attachment.t],
     from: MicrosoftBot.Models.ChannelAccount.t, to: MicrosoftBot.Models.ChannelAccount.t,
     replyToMessageId: String.t, participants: [MicrosoftBot.Models.ChannelAccount.t],
     totalParticipants: Integer.t, mentions: [MicrosoftBot.Models.Mention.t],
     place: String.t, channelMessageId: String.t, channelConversationId: String.t,
     channelData: map, botUserData: map, botConversationData: map, botPerUserInConversationData: map,
     location: MicrosoftBot.Models.Location.t, hashtags: [String.t], eTag: String.t
   }

   @doc """
   Decode a map into `MicrosoftBot.Models.Message`
   """
   @spec parse(map) :: MicrosoftBot.Models.Message.t
   def parse(param) when is_map(param) do
     Poision.Decode.decode(param, as: decoding_map)
   end

   @doc """
   Decode a string into `MicrosoftBot.Models.Message`
   """
   @spec parse(String.t) :: MicrosoftBot.Models.Message.t
   def parse(param) when is_binary(param) do
     Poison.decode!(param, as: decoding_map)
   end

   @doc false
   def decoding_map do
     %MicrosoftBot.Models.Message {
       "attachments": [MicrosoftBot.Models.Attachment.decoding_map],
       "from": MicrosoftBot.Models.ChannelAccount.decoding_map,
       "to": MicrosoftBot.Models.ChannelAccount.decoding_map,
       "participants": MicrosoftBot.Models.ChannelAccount.decoding_map,
       "mentions": [MicrosoftBot.Models.Mention.decoding_map],
       "location": MicrosoftBot.Models.Location.decoding_map
     }
   end
end
