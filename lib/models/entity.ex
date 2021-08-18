defmodule ExMicrosoftBot.Models.Entity do
  @moduledoc """
  Microsoft bot entity structure
  """

  alias ExMicrosoftBot.Models.Entity.Mention

  @derive [Poison.Encoder]
  defstruct [
    :type,

    # type == "?"
    :name,
    :supportsDisplay,

    # type == "clientInfo"
    :country,
    :locale,
    :platform,
    :timezone,

    # type == "mention"
    :mentioned,
    :text
  ]

  @type t :: %ExMicrosoftBot.Models.Entity{
          type: String.t(),
          name: String.t() | nil,
          supportsDisplay: boolean() | nil,
          country: String.t() | nil,
          locale: String.t() | nil,
          platform: String.t() | nil,
          timezone: String.t() | nil,
          mentioned: Mention.t() | nil,
          text: String.t() | nil
        }

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.Entity{
      mentioned: Mention.decoding_map()
    }
  end
end
