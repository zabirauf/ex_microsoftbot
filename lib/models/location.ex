defmodule MicrosoftBot.Models.Location do
  @moduledoc """
  Microsoft bot location structure
  """

  @derive [Poison.Encoder]
  defstruct [:altitude, :latitude, :longitude, :name]

  @type t :: %MicrosoftBot.Models.Location {
    altitude: integer, latitude: integer, longitude: integer, name: String.t
  }

  @doc false
  def decoding_map do
    %MicrosoftBot.Models.Location{}
  end
end
