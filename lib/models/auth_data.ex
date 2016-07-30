defmodule ExMicrosoftBot.Models.AuthData do
  @moduledoc """
  Contains authorization related info to call the microsoft bot API
  """

  defstruct [:app_id, :app_password]

  @type t :: %ExMicrosoftBot.Models.AuthData {
    app_id: String.t,
    app_password: String.t
  }
end
