defmodule ExMicrosoftBot.TokenManager do
  @moduledoc """
  This module is a GenServer that handles getting access token from
  Microsoft bot framework and also is responsible for refreshing the token
  before it expires.
  """
  use ExMicrosoftBot.RefreshableAgent

  alias ExMicrosoftBot.Models
  alias ExMicrosoftBot.Client

  ################################################
  ##### Functions to interact with GenServer #####
  ################################################

  @doc """
  Get the token that can be used to authorize calls to Microsoft Bot Framework
  """
  def get_token() do
    [token: token] = get_state

    token
  end

  #######################################
  ##### Refreshable Agent Callbacks #####
  #######################################

  @default_time_gap_to_refresh_in_seconds 500
  @doc """
  Refresh the token by making a service call and then scheduling a message to
  this GenServer before token expires so that it can be refreshed
  """
  def get_refreshed_state(%Models.AuthData{} = auth_data, _old_state) do
    refresh_token(auth_data)
    |> validate_token
  end

  def time_to_refresh_after_in_seconds([expiry_in_seconds: expiry_in_seconds]) do
    expiry_time_in_seconds = (expiry_in_seconds - @default_time_gap_to_refresh_in_seconds)
    expiry_time_in_seconds
  end

  ###############################
  ####### Helper functions ######
  ###############################

  defp validate_token([token: token] = token_response) do
    # TODO: See what other checks are needed to verify the JWT
    token
    |> JOSE.JWT.from_binary

    token_response
  end

  @auth_api_endpoint "https://login.microsoftonline.com/common/oauth2/v2.0/token"
  defp refresh_token(%Models.AuthData{} = auth_data) do
    {:ok, token_response} = get_token_from_service(auth_data)

    [
      token: Map.get(token_response, "access_token"),
      expiry_in_seconds: Map.get(token_response, "expires_in")
    ]
  end

  defp get_token_from_service(%Models.AuthData{app_id: app_id, app_password: app_password}) do
    body = %{
      grant_type: "client_credentials",
      client_id: app_id,
      client_secret: app_password,
      scope: "https://graph.microsoft.com/.default"
    }

    HTTPotion.post(@auth_api_endpoint, [body: Poison.encode!(body)])
    |> Client.deserialize_response(&(Poison.decode!(&1, as: %{})))
  end

end
