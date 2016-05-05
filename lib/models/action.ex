defmodule MicrosoftBot.Models.Action do
  @moduledoc """
  Microsoft bot action structure
  """

  @derive [Poison.Encoder]
  defstruct [:title, :image, :message, :url]

  @type t :: %MicrosoftBot.Models.Action {
    title: String.t, image: String.t, message: String.t, url: String.t
  }

  @doc false
  def decoding_map do
    %MicrosoftBot.Models.Action{}
  end
end
