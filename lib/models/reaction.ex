defmodule ExMicrosoftBot.Models.Reaction do
  @moduledoc """
  Microsoft bot structure which corresponds to a Reaction on a message
  """

  @derive [Poison.Encoder]
  defstruct [:type]

  @type t :: %ExMicrosoftBot.Models.Reaction{
          type: String.t()
        }

  @doc """
  Decode a map into `ExMicrosoftBot.Models.Reaction`
  """
  @spec parse(map) :: {:ok, ExMicrosoftBot.Models.Reaction.t()}
  def parse(param) when is_map(param) do
    {:ok, Poison.Decode.transform(param, %{as: decoding_map()})}
  end

  @doc """
  Decode a list of maps into a list of `ExMicrosoftBot.Models.Reaction`
  """
  @spec parse(list) :: {:ok, [ExMicrosoftBot.Models.Reaction.t()]}
  def parse(param) when is_list(param) do
    {:ok, Poison.Decode.transform(param, %{as: [decoding_map()]})}
  end

  @doc """
  Decode a string into `ExMicrosoftBot.Models.Reaction`
  """
  @spec parse(String.t()) :: ExMicrosoftBot.Models.Reaction.t()
  def parse(param) when is_binary(param) do
    elem(parse(Poison.decode!(param)), 1)
  end

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.Reaction{}
  end
end
