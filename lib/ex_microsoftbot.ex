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

  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      worker(ExMicrosoftBot.TokenManager, [get_auth_data()]),
      worker(ExMicrosoftBot.SigningKeysManager, [])
    ]

    opts = [strategy: :one_for_one, name: ExMicrosoftBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Private

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
