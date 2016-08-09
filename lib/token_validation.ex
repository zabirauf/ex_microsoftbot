defmodule ExMicrosoftBot.TokenValidation do
  @moduledoc """
  This module provides functions to validate the authorization token recived by the bot service
  from the Microsoft Bot Framework
  """

  require Logger
  alias ExMicrosoftBot.SigningKeysManager

  @expected_issuer_claim Application.get_env(:ex_microsoftbot, :issuer_claim)
  @expected_audience_claim Application.get_env(:ex_microsoftbot, :app_id)

  @doc """
  Helper function to validate the authentication information for the bot
  """
  @spec validate_bot_credentials?(Keyword.t) :: boolean
  def validate_bot_credentials?(headers) do

    # Convert the list of key value tuple to a map and get the authorization header
    auth_header = Enum.reduce(headers, %{}, fn ({k, v}, acc) -> Map.put(acc, k, v) end)
    |> Map.get("authorization", nil)

    case auth_header do
      "Bearer " <> auth_token -> validate_auth_token(auth_token)
      _ -> false
    end
  end

  defp validate_auth_token(token) do
    with {:ok, jwt, _jws} <- get_jwt_from_string(token),
          true <- contains_valid_issuer?(jwt),
          true <- contains_valid_audience?(jwt),
          true <- contains_valid_app_id_claim?(jwt),
          true <- token_not_expired?(jwt),
          true <- has_valid_cryptographic_sig?(jwt)
          do
            true
          else
            _ -> false
    end
  end

  defp get_jwt_from_string(token) do
    try do
      {:ok, JOSE.JWT.peek_payload(token), JOSE.JWT.peek_protected(token)}
    rescue
      _ -> {:error, "Unable to parse the token"}
    end
  end

  defp contains_valid_issuer?(%JOSE.JWT{fields: %{"iss" => @expected_issuer_claim}}), do: true
  defp contains_valid_issuer?(%JOSE.JWT{}), do: false

  defp contains_valid_audience?(%JOSE.JWT{fields: %{"aud" => @expected_audience_claim}}), do: true
  defp contains_valid_audience?(%JOSE.JWT{}), do: false

  defp contains_valid_app_id_claim?(%JOSE.JWT{} = jwt) do
    contains_valid_app_id_claim?(jwt, Application.get_env(:ex_microsoftbot, :bot_emulator_extra_varification))
  end
  defp contains_valid_app_id_claim?(%JOSE.JWT{fields: %{"appid" => app_id}}, true), do: app_id == Application.get_env(:ex_microsoftbot, :app_id)
  defp contains_valid_app_id_claim?(_, true), do: false # In case extra bot validation is required and app id isn't in claim then fail
  defp contains_valid_app_id_claim?(_, _), do: true # This will occur for prod

  defp token_not_expired?(%JOSE.JWT{fields: %{"exp" => expiry}}) do
    with expiry_time <- Timex.from_unix(expiry),
         time_to_compare_with <- (Timex.now |> Timex.shift(minutes: 5)),
         true <- Timex.before?(expiry_time, time_to_compare_with)
         do
           true
         else
           _ -> false
         end
  end

  defp has_valid_cryptographic_sig?(auth_header) do
    SigningKeysManager.get_keys()
    |> Enum.map(fn (key) ->
      JOSE.JWK.verify(auth_header, key)
    end)
    |> Enum.filter(fn (val) -> val == true end)
    |> length
    |> Kernel.>(0)
  end
end
