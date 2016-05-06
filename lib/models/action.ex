defmodule ExMicrosoftBot.Models.Action do
  @moduledoc """
  Microsoft bot action structure
  """

  @derive [Poison.Encoder]
  defstruct [:title, :image, :message, :url]

  @type t :: %ExMicrosoftBot.Models.Action {
    title: String.t, image: String.t, message: String.t, url: String.t
  }

  @doc false
  def decoding_map do
    %ExMicrosoftBot.Models.Action{}
  end
end
