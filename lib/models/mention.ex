defmodule ExMicrosoftBot.Models.Mention do
  @moduledoc """
  Microsoft bot mention structure
  """

  @derive [Poison.Encoder]
  defstruct [:mentioned, :text]

  @type t :: %ExMicrosoftBot.Models.Mention {
    mentioned: ExMicrosoftBot.Models.ChannelAccount.t, text: String.t
  }

  @doc false
  def decoding_map do
    %ExMicrosoftBot.Models.Mention{
      "mentioned": ExMicrosoftBot.Models.ChannelAccount.decoding_map
    }
  end
end
