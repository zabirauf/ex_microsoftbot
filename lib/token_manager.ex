defmodule ExMicrosoftBot.TokenManager do
  use GenServer

  alias ExMicrosoftBot.Models
  alias ExMicrosoftBot.Client

  ################################################
  ##### Functions to interact with GenServer #####
  ################################################

  def start_link(auth_data) do
    GenServer.start_link(__MODULE__, [auth_data: auth_data], name: __MODULE__)
  end

  @doc """
  Get the token that can be used to authorize calls to Microsoft Bot Framework
  """
  def get_token() do
    GenServer.call(__MODULE__, :get_token)
  end

  ###############################
  ##### GenServer Callbacks #####
  ###############################

  def init([auth_data: auth_data]) do
    state = refresh_token_and_schedule_next_refresh(auth_data)
    |> Keyword.merge([auth_data: auth_data], fn (_k, v1, _v2) -> v1 end)

    {:ok, state}
  end

  def handle_call(:get_token, _from, [token: token] = state) do
    {:reply, token, state}
  end

  def handle_info(:refresh, [auth_data: auth_data] = state) do
    new_state = refresh_token_and_schedule_next_refresh(auth_data)
    |> Keyword.merge(state, fn(_k, v1, _v2) -> v1 end)

    {:noreply, new_state}
  end

  ###############################
  ####### Helper functions ######
  ###############################

  @default_time_gap_to_refresh_in_seconds 500
  @doc """
  Refresh the token by making a service call and then scheduling a message to
  this GenServer before token expires so that it can be refreshed
  """
  defp refresh_token_and_schedule_next_refresh(%Models.AuthData{} = auth_data) do
    refresh_token(auth_data)
    |> validate_token
    |> schedule_next_refresh
    |> remove_unnecessary_data_from_token_response
  end

  defp validate_token([token: token] = token_response) do
    # TODO: See what other checks are needed to verify the JWT
    token
    |> JOSE.JWT.from_binary

    token_response
  end

  defp schedule_next_refresh([expiry_in_seconds: expiry_in_seconds] = token_response) do
    # We give some buffer before the token expires so that we can refresh without make some failed calls
    expiry_time_in_ms = (expiry_in_seconds - @default_time_gap_to_refresh_in_seconds) * 1000
    timer_ref = Process.send_after(__MODULE__, :refresh, expiry_time_in_ms)

    Keyword.put(token_response, :timer_ref, timer_ref)
  end

  defp remove_unnecessary_data_from_token_response(token_response) do
    token_response
    |> Keyword.delete(:expiry_in_seconds)
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
