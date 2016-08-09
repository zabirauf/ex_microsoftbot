defmodule ExMicrosoftBot.TokenValidation do
  @moduledoc """
  This module provides functions to validate the authorization token recived by the bot service
  from the Microsoft Bot Framework
  """

  require Logger
  alias ExMicrosoftBot.SigningKeysManager

  @doc """
  Helper function to validate the authentication information for the bot
  """
  @spec validate_bot_credentials?(Keyword.t) :: boolean
  def validate_bot_credentials?(headers) do
    Logger.debug "ExMicrosoftBot.TokenValidation.validate_bot_credentials?: Going to validate the bot credentials"
    validate_bot_credentials?(headers, Application.get_env(:ex_microsoftbot, :disable_token_validation))
  end

  @spec validate_bot_credentials?(Keyword.t, boolean) :: boolean
  defp validate_bot_credentials?(_headers, true) do
    Logger.debug "ExMicrosoftBot.TokenValidation.validate_bot_credentials?: Going to skip token validation as its an emulator"
    true # In case bot emulator is used ignore the credentials
  end

  defp validate_bot_credentials?(headers, _) do
    Logger.debug "ExMicrosoftBot.TokenValidation.validate_bot_credentials?: Getting the authorization header and validating"
    # Convert the list of key value tuple to a map and get the authorization header
    auth_header = Enum.reduce(headers, %{}, fn ({k, v}, acc) -> Map.put(acc, k, v) end)
    |> Map.get("authorization", nil)

    case auth_header do
      "Bearer " <> auth_token ->
        validate_auth_token(auth_token)
      _ ->
        Logger.debug "ExMicrosoftBot.TokenValidation.validate_bot_credentials? Failed"
        false
    end
  end

  defp validate_auth_token(token) do
    with {:ok, jwt, _jws} <- get_jwt_from_string(token),
          true <- contains_valid_issuer?(jwt),
          true <- contains_valid_audience?(jwt),
          true <- contains_valid_app_id_claim?(jwt),
          true <- token_not_expired?(jwt),
          true <- has_valid_cryptographic_sig?(token) do
            Logger.debug "ExMicrosoftBot.TokenValidation.validate_auth_token: Passed"
            true
          else
            failure_value ->
              Logger.debug "ExMicrosoftBot.TokenValidation.validate_auth_token: Failed #{inspect(failure_value)}"
              false
    end
  end

  defp get_jwt_from_string(token) do
    try do
      Logger.debug "ExMicrosoftBot.TokenValidation.get_jwt_from_string: Going to parse token"
      {:ok, JOSE.JWT.peek_payload(token), JOSE.JWT.peek_protected(token)}
    rescue
      _ ->
        Logger.debug "ExMicrosoftBot.TokenValidation.get_jwt_from_string: Failed"
        {:error, "Unable to parse the token"}
    end
  end

  defp expected_issuer_claim, do: Application.get_env(:ex_microsoftbot, :issuer_claim)

  defp contains_valid_issuer?(%JOSE.JWT{} = jwt), do: contains_valid_issuer?(expected_issuer_claim, jwt)

  defp contains_valid_issuer?(issuer_claim, %JOSE.JWT{fields: %{"iss" => issuer_claim}}), do: true
  defp contains_valid_issuer?(_issuer_claim, %JOSE.JWT{}) do
    Logger.debug "ExMicrosoftBot.TokenValidation.contains_valid_issuer? Failed"
    false
  end

  defp expected_audience_claim, do: Application.get_env(:ex_microsoftbot, :app_id)

  defp contains_valid_audience?(%JOSE.JWT{} = jwt), do: contains_valid_audience?(expected_audience_claim, jwt)

  defp contains_valid_audience?(audience_claim, %JOSE.JWT{fields: %{"aud" => audience_claim}}), do: true
  defp contains_valid_audience?(_audience_claim, %JOSE.JWT{}) do
    Logger.debug "ExMicrosoftBot.TokenValidation.contains_valid_audience? Failed"
    false
  end

  defp contains_valid_app_id_claim?(%JOSE.JWT{} = jwt) do
    contains_valid_app_id_claim?(jwt, Application.get_env(:ex_microsoftbot, :using_bot_emulator))
  end
  defp contains_valid_app_id_claim?(%JOSE.JWT{fields: %{"appid" => app_id}}, true), do: app_id == Application.get_env(:ex_microsoftbot, :app_id)
  defp contains_valid_app_id_claim?(_, true), do: false # In case extra bot validation is required and app id isn't in claim then fail
  defp contains_valid_app_id_claim?(_, _), do: true # This will occur for prod

  defp token_not_expired?(%JOSE.JWT{fields: %{"exp" => expiry}}) do
    with expiry_time <- Timex.from_unix(expiry),
         time_to_compare_with <- (Timex.now |> Timex.shift(minutes: 5)),
         true <- Timex.before?(time_to_compare_with, expiry_time) do
           true
         else
           _ ->
             Logger.debug "ExMicrosoftBot.TokenValidation.token_not_expired? Failed"
             false
         end
  end

  defp has_valid_cryptographic_sig?(token) do
    SigningKeysManager.get_keys()
    |> Enum.map(fn (key) ->
      JOSE.JWT.verify(key, token)
    end)
    |> Enum.map(fn ({val, _, _}) -> val end)
    |> Enum.filter(fn (val) -> val == true end)
    |> length
    |> Kernel.>(0)
  end

end
