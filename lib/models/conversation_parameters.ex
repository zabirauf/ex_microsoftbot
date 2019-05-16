defmodule ExMicrosoftBot.Models.ConversationParameters do
  @moduledoc """
  Microsoft bot conversation API parameters
  """

  @derive [Poison.Encoder]
  defstruct [:isGroup, :bot, :members, :topicName, :activity, :channelData]

  @type t :: %ExMicrosoftBot.Models.ConversationParameters{
    isGroup: boolean,
    bot: ExMicrosoftBot.Models.ChannelAccount.t,
    members: [ExMicrosoftBot.Models.ChannelAccount.t],
    topicName: String.t,
    activity: ExMicrosoftBot.Models.Activity.t,
    channelData: map
  }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.ConversationParameters{
      bot: ExMicrosoftBot.Models.ChannelAccount.decoding_map(),
      members: [ExMicrosoftBot.Models.ChannelAccount.decoding_map()]
    }
  end
end
