defmodule ExMicrosoftBot.Models.ChannelAccount do
  @moduledoc """
  Microsoft bot channel account structure which corresponde to a user or bot
  """

  @derive [Poison.Encoder]
  defstruct [:id, :name, :aadObjectId, :objectId, :givenName, :surname, :email, :userPrincipalName, :tenantId]

  @type t :: %ExMicrosoftBot.Models.ChannelAccount{
    id: String.t,
    name: String.t,
    aadObjectId: String.t,
               objectId: String.t(),
               givenName: String.t(),
               surname: String.t(),
               email: String.t(),
               userPrincipalName: String.t(),
               tenantId: String.t()
  }

  @doc """
  Decode a map into `ExMicrosoftBot.Models.ChannelAccount`
  """
  @spec parse(map) :: {:ok, ExMicrosoftBot.Models.ChannelAccount.t()}
  def parse(param) when is_map(param) do
    {:ok, Poison.Decode.transform(param, %{as: decoding_map()})}
  end

  @doc """
  Decode a list of maps into a list of `ExMicrosoftBot.Models.ChannelAccount`
  """
  @spec parse(list) :: {:ok, [ExMicrosoftBot.Models.ChannelAccount.t()]}
  def parse(param) when is_list(param) do
    {:ok, Poison.Decode.transform(param, %{as: [decoding_map()]})}
  end

  @doc """
  Decode a string into `ExMicrosoftBot.Models.ChannelAccount`
  """
  @spec parse(String.t()) :: ExMicrosoftBot.Models.ChannelAccount.t()
  def parse(param) when is_binary(param) do
    elem(parse(Poison.decode!(param)), 1)
  end

  @doc false
  def decoding_map() do
    %ExMicrosoftBot.Models.ChannelAccount{}
  end
end
