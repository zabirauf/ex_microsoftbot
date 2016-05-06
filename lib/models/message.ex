defmodule ExMicrosoftBot.Models.Message do
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

   @type t :: %ExMicrosoftBot.Models.Message{
     type: String.t, id: String.t, conversationId: String.t, created: String.t,
     sourceText: String.t, sourceLanguage: String.t, language: String.t,
     text: String.t, attachments: [ExMicrosoftBot.Models.Attachment.t],
     from: ExMicrosoftBot.Models.ChannelAccount.t, to: ExMicrosoftBot.Models.ChannelAccount.t,
     replyToMessageId: String.t, participants: [ExMicrosoftBot.Models.ChannelAccount.t],
     totalParticipants: Integer.t, mentions: [ExMicrosoftBot.Models.Mention.t],
     place: String.t, channelMessageId: String.t, channelConversationId: String.t,
     channelData: map, botUserData: map, botConversationData: map, botPerUserInConversationData: map,
     location: ExMicrosoftBot.Models.Location.t, hashtags: [String.t], eTag: String.t
   }

   @doc """
   Decode a map into `ExMicrosoftBot.Models.Message`
   """
   @spec parse(map) :: {:ok, ExMicrosoftBot.Models.Message.t}
   def parse(param) when is_map(param) do
     {:ok, Poison.Decode.decode(param, as: decoding_map)}
   end

   @doc """
   Decode a string into `ExMicrosoftBot.Models.Message`
   """
   @spec parse(String.t) :: ExMicrosoftBot.Models.Message.t
   def parse(param) when is_binary(param) do
     Poison.decode!(param, as: decoding_map)
   end

   @doc """
   Encodes the `ExMicrosoftBot.Models.Message` to json string
   """
   @spec serialize(ExMicrosoftBot.Models.Message.t) :: String.t
   def serialize(%ExMicrosoftBot.Models.Message{} = message) do
     Poison.encode!(message)
   end

   @doc false
   def decoding_map do
     %ExMicrosoftBot.Models.Message {
       "attachments": [ExMicrosoftBot.Models.Attachment.decoding_map],
       "from": ExMicrosoftBot.Models.ChannelAccount.decoding_map,
       "to": ExMicrosoftBot.Models.ChannelAccount.decoding_map,
       "participants": [ExMicrosoftBot.Models.ChannelAccount.decoding_map],
       "mentions": [ExMicrosoftBot.Models.Mention.decoding_map],
       "location": ExMicrosoftBot.Models.Location.decoding_map
     }
   end
end
