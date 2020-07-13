defmodule ExMicrosoftBot.Models.ResourceResponse do
  @moduledoc """
  Microsoft bot conversation API resource response
  """

  @derive [Poison.Encoder]
  defstruct [:id]

  @type t :: %ExMicrosoftBot.Models.ResourceResponse{
          id: String.t()
        }

  @doc """
  Decode a map into `ExMicrosoftBot.Models.ResourceResponse`
  """
  @spec parse(map) :: {:ok, ExMicrosoftBot.Models.ResourceResponse.t()}
  def parse(param) when is_map(param) do
    {:ok, Poison.Decode.transform(param, %{as: decoding_map()})}
  end

  @doc """
  Decode a string into `ExMicrosoftBot.Models.ResourceResponse`
  """
  @spec parse(String.t()) :: ExMicrosoftBot.Models.ResourceResponse.t()
  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map())
  end

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.ResourceResponse{}
  end
end
