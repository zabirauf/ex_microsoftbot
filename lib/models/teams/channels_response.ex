defmodule ExMicrosoftBot.Models.Teams.ChannelsResponse do
  @moduledoc """
  Schema representing the return of the Channels list for a team.
  """

  alias ExMicrosoftBot.Models

  @derive [Poison.Encoder]
  defstruct [:conversations]

  @type t :: %__MODULE__{
          conversations: [Models.ChannelAccount.t()]
        }

  @doc "Converts a map into this struct."
  @spec parse(map()) :: {:ok, __MODULE__.t()}
  def parse(map) when is_map(map) do
    {:ok, Poison.Decode.transform(map, %{as: decoding_map()})}
  end

  @doc "Decodes a JSON string into this struct."
  @spec parse(String.t()) :: __MODULE__.t()
  def parse(json) when is_binary(json) do
    Poison.decode!(json, as: decoding_map())
  end

  @doc false
  def decoding_map do
    %__MODULE__{
      conversations: [Models.ChannelAccount.decoding_map()]
    }
  end
end
