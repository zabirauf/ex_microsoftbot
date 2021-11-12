defmodule ExMicrosoftBot.Models.PagedMembersResult do
  @moduledoc """
  BotFramework structure for returning paginated conversation member data.
  @see [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#pagedmembersresult-object)
  """

  @derive [Poison.Encoder]
  defstruct [:members, :continuationToken]

  @type t :: %__MODULE__{
          members: [ExMicrosoftBot.Models.ChannelAccount.t()],
          continuationToken: String.t() | nil
        }

  @doc """
  Decodes a map into `ExMicrosoftBot.Models.PagedMembersResult`
  """
  @spec parse(map :: map()) :: {:ok, __MODULE__.t()}
  def parse(map) when is_map(map) do
    {:ok, Poison.Decode.transform(map, %{as: decoding_map()})}
  end

  @doc """
  Decodes a JSON string into `ExMicrosoftBot.Models.PagedMembersResult`
  """
  @spec parse(json :: String.t()) :: __MODULE__.t()
  def parse(json) when is_binary(json) do
    elem(parse(Poison.decode!(json)), 1)
  end

  @doc false
  def decoding_map() do
    %__MODULE__{
      members: [ExMicrosoftBot.Models.ChannelAccount.decoding_map()]
    }
  end
end
