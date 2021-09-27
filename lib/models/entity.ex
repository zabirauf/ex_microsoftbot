defmodule ExMicrosoftBot.Models.Entity do
  @moduledoc """
  Microsoft bot entity structure.

  Depending on the `type` value, different fields in the struct will be used.
  See defined types for more info.
  """

  alias ExMicrosoftBot.Models.Entity.Mention

  @derive [Poison.Encoder]
  defstruct [
    :type,
    :name,
    :supportsDisplay,
    :country,
    :locale,
    :platform,
    :timezone,
    :mentioned,
    :text
  ]

  @typedoc """
  Known types thus far: "clientInfo" & "mention".
  """
  @type entity_type :: String.t()

  @type t ::
          %ExMicrosoftBot.Models.Entity{
            type: entity_type(),
            name: String.t() | nil,
            supportsDisplay: boolean() | nil
          }

          # type == clientInfo
          | %ExMicrosoftBot.Models.Entity{
              type: entity_type(),
              country: String.t() | nil,
              locale: String.t() | nil,
              platform: String.t() | nil,
              timezone: String.t() | nil
            }

          # type == "mention"
          | %ExMicrosoftBot.Models.Entity{
              type: entity_type(),
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
