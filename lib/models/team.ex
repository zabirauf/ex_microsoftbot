defmodule ExMicrosoftBot.Models.Team do
  @moduledoc """
  This structure represents a Team as it is returned from the Bot Framework API.
  """

  @derive [Poison.Encoder]
  defstruct [:id, :name, :aadGroupId]

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          aadGroupId: String.t()
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
    %__MODULE__{}
  end
end
