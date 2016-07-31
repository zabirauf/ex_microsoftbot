defmodule ExMicrosoftBot do
  @moduledoc """
  Starts the application for connecting to Microsoft Bot Services.
  Make sure that the application id and password for your bot is set
  in config as

  ```
  config :ex_microsoftbot,
    app_id: "BOT_APP_ID",
    app_password: "BOT_APP_PASSWORD"
  ```
  """

  require Logger
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(ExMicrosoftBot.TokenManager, [get_auth_data])
    ]

    supervise(children, strategy: :one_for_one)
  end

  defp get_auth_data do
    app_id = Application.get_env(:ex_microsoftbot, :app_id)
    app_password = Application.get_env(:ex_microsoftbot, :app_password)

    create_auth_data(app_id, app_password)
  end

  defp create_auth_data(nil, _), do: throw("No auth data defined for ex_microsoftbot.")
  defp create_auth_data(_, nil), do: throw("No auth data defined for ex_microsoftbot.")
  defp create_auth_data(app_id, app_password) do
    %ExMicrosoftBot.Models.AuthData{
      app_id: app_id,
      app_password: app_password
    }
  end
end
