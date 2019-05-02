defmodule ExMicrosoftBot.Models.Attachment do
  @moduledoc """
  Microsoft bot attachment structure within the message
  """

  @derive [Poison.Encoder]
  defstruct [
    :contentType, :contentUrl, :content,
    :name, :thumbnailUrl
  ]

  @type t :: %ExMicrosoftBot.Models.Attachment{
    contentType: String.t,
    contentUrl: String.t,
    content: String.t | map,
    name: String.t,
    thumbnailUrl: String.t
  }

  @doc """
  Decode a map into `ExMicrosoftBot.Models.Attachment`
  """
  @spec parse(map) :: {:ok, ExMicrosoftBot.Models.Attachment.t}
  def parse(param) when is_map(param) do
    {:ok, Poison.Decode.decode(param, as: decoding_map())}
  end

  @doc """
  Decode a string into `ExMicrosoftBot.Models.Attachment`
  """
  @spec parse(String.t) :: ExMicrosoftBot.Models.Attachment.t
  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map())
  end

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.Attachment{}
  end
end
