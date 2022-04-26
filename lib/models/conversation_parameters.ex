defmodule ExMicrosoftBot.Models.ConversationParameters do
  @moduledoc """
  Microsoft bot conversation API parameters
  """

  @derive [Poison.Encoder]
  defstruct [:activity, :bot, :channelData, :isGroup, :members, :tenantId, :topicName]

  @type t :: %ExMicrosoftBot.Models.ConversationParameters{
          activity: ExMicrosoftBot.Models.Activity.t(),
          bot: ExMicrosoftBot.Models.ChannelAccount.t(),
          channelData: map,
          isGroup: boolean,
          members: [ExMicrosoftBot.Models.ChannelAccount.t()],
          tenantId: String.t(),
          topicName: String.t()
        }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.ConversationParameters{
      bot: ExMicrosoftBot.Models.ChannelAccount.decoding_map(),
      members: [ExMicrosoftBot.Models.ChannelAccount.decoding_map()]
    }
  end
end
