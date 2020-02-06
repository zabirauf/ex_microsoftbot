defmodule ExMicrosoftBot.Models.AttachmentInfo do
  @moduledoc """
  Microsoft bot attachment info structure
  """

  alias ExMicrosoftBot.Models.AttachmentView

  @derive [Poison.Encoder]
  defstruct [:name, :type, :views]

  @type t :: %ExMicrosoftBot.Models.AttachmentInfo{
    name: String.t,
    type: String.t,
    views: [AttachmentView]
  }

  @doc """
  Decode a map into `ExMicrosoftBot.Models.AttachmentInfo`
  """
  @spec parse(map) :: {:ok, ExMicrosoftBot.Models.AttachmentInfo.t}
  def parse(param) when is_map(param) do
    {:ok, Poison.Decode.transform(param, %{as: decoding_map()})}
  end

  @doc """
  Decode a string into `ExMicrosoftBot.Models.AttachmentInfo`
  """
  @spec parse(String.t) :: ExMicrosoftBot.Models.AttachmentInfo.t
  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map())
  end

  @doc """
  Encodes the `ExMicrosoftBot.Models.AttachmentInfo` to json string
  """
  @spec serialize(ExMicrosoftBot.Models.AttachmentInfo.t) :: String.t
  def serialize(%ExMicrosoftBot.Models.AttachmentInfo{} = bot_data) do
    Poison.encode!(bot_data)
  end

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.AttachmentInfo {
      views: [AttachmentView.decoding_map()]
    }
  end
end
