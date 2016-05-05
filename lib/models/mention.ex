defmodule MicrosoftBot.Models.Mention do
  @moduledoc """
  Microsoft bot mention structure
  """

  @derive [Poison.Encoder]
  defstruct [:mentioned, :text]

  @type t :: %MicrosoftBot.Models.Mention {
    mentioned: MicrosoftBot.Models.ChannelAccount.t, text: String.t
  }

  @doc false
  def decoding_map do
    %MicrosoftBot.Models.Mention{
      "mentioned": MicrosoftBot.Models.ChannelAccount.decoding_map
    }
  end
end
