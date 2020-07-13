defmodule ExMicrosoftBot.Models.ConversationResourceResponse do
  @moduledoc """
  Microsoft bot conversation API response when creating a conversation.
  https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#conversationresourceresponse-object
  """

  @derive [Poison.Encoder]
  defstruct [:id, :activityId, :serviceUrl]

  @type t :: %__MODULE__{
          id: String.t(),
          activityId: String.t() | nil,
          serviceUrl: String.t()
        }

  @spec parse(String.t() | Map.t()) :: __MODULE__.t() | {:ok, __MODULE__.t()}
  def parse(param) when is_map(param) do
    {:ok, Poison.Decode.transform(param, %{as: decoding_map()})}
  end

  def parse(param) do
    Poison.decode!(param, as: decoding_map())
  end

  @doc false
  def decoding_map() do
    %__MODULE__{}
  end
end
