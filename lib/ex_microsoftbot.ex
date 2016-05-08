defmodule ExMicrosoftBot.Client do
  @moduledoc """
  Use the Microsoft bot framework to create bots for multiple different platforms.
  This client provides API to use the Microsoft bot framework.
  """
  alias ExMicrosoftBot.Models, as: Models

  @type error_type :: {:error, integer, String.t}
  @type bot_data_type :: {:ok, Models.BotData.t}

  @endpoint "https://api.botframework.com"

  @doc """
  This functions allows you to initiate a new conversation message with a user. [API Reference](http://docs.botframework.com/sdkreference/restapi/#!/Messages/Messages_SendMessage)
  """
  @spec send_message(Models.AuthData.t, map) :: {:ok, Models.Message.t} | error_type
  def send_message(%Models.AuthData{} = auth_data, %{} = message) do
    api_endpoint = "#{@endpoint}/bot/v1.0/messages"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(message), headers: headers(auth_data, api_endpoint)])
    |> deserialize_response(&Models.Message.parse/1)
  end

  @doc """
  Get a BotData record for the user. [API Reference](http://docs.botframework.com/sdkreference/restapi/#!/Bots/Bots_GetUserData)
  """
  @spec get_user_data(Models.AuthData.t, String.t, String.t) :: bot_data_type | error_type
  def get_user_data(%Models.AuthData{} = auth_data, bot_id, user_id) do
    api_endpoint = "#{@endpoint}/bot/v1.0/bots/#{bot_id}/users/#{user_id}"

    HTTPotion.get(api_endpoint, [headers: headers(auth_data, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Update the bot user data. [API Reference](http://docs.botframework.com/sdkreference/restapi/#!/Bots/Bots_SetUserData)
  """
  @spec set_user_data(Models.AuthData.t, String.t, String.t, map) :: bot_data_type | error_type
  def set_user_data(%Models.AuthData{} = auth_data, bot_id, user_id, data) do
    api_endpoint = "#{@endpoint}/bot/v1.0/bots/#{bot_id}/users/#{user_id}"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(data), headers: headers(auth_data, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Get the bot data for conversation. [API Reference](http://docs.botframework.com/sdkreference/restapi/#!/Bots/Bots_GetConversationData)
  """
  @spec get_conversation_data(Models.AuthData.t, String.t, String.t) :: bot_data_type | error_type
  def get_conversation_data(%Models.AuthData{} = auth_data, bot_id, conversation_id) do
    api_endpoint = "#{@endpoint}/bot/v1.0/bots/#{bot_id}/conversations/#{conversation_id}"

    HTTPotion.get(api_endpoint, [headers: headers(auth_data, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Update the bot conversation data. [API Reference](http://docs.botframework.com/sdkreference/restapi/#!/Bots/Bots_SetConversationData)
  """
  @spec set_conversation_data(Models.AuthData.t, String.t, String.t, map) :: bot_data_type | error_type
  def set_conversation_data(%Models.AuthData{} = auth_data, bot_id, conversation_id, data) do
    api_endpoint = "#{@endpoint}/bot/v1.0/bots/#{bot_id}/conversations/#{conversation_id}"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(data), headers: headers(auth_data, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Get the bot data for a user in conversation. [API Reference](http://docs.botframework.com/sdkreference/restapi/#!/Bots/Bots_GetPerUserConversationData)
  """
  @spec get_per_user_conversation_data(Models.AuthData.t, String.t, String.t, String.t) :: bot_data_type | error_type
  def get_per_user_conversation_data(%Models.AuthData{} = auth_data, bot_id, conversation_id, user_id) do
    api_endpoint = "#{@endpoint}/bot/v1.0/bots/#{bot_id}/conversations/#{conversation_id}/users/#{user_id}"

    HTTPotion.get(api_endpoint, [headers: headers(auth_data, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Update the bot user in a conversation data. [API Reference](http://docs.botframework.com/sdkreference/restapi/#!/Bots/Bots_SetPerUserInConversationData)
  """
  @spec set_per_user_conversation_data(Models.AuthData.t, String.t, String.t, String.t, map) :: bot_data_type | error_type
  def set_per_user_conversation_data(%Models.AuthData{} = auth_data, bot_id, conversation_id, user_id, data) do
    api_endpoint = "#{@endpoint}/bot/v1.0/bots/#{bot_id}/conversations/#{conversation_id}/users/#{user_id}"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(data), headers: headers(auth_data, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Helper function to validate the authentication information for the bot
  """
  @spec validate_bot_credentials(Models.AuthData.t, Keyword.t) :: boolean
  def validate_bot_credentials(%Models.AuthData{} = auth_data, headers) do

    # Convert the list of key value tuple to a map and get the authorization header
    auth_header = Enum.reduce(headers, %{}, fn ({k, v}, acc) -> Map.put(acc, k, v) end)
    |> Map.get("authorization", nil)

    case auth_header do
      "Basic " <> val -> val == create_encoded_auth_headers(auth_data)
      _ -> false
    end
  end

  defp deserialize_response(%HTTPotion.Response{status_code: 200, body: body}, deserialize_func) do
    {:ok, deserialize_func.(body)}
  end

  defp deserialize_response(%HTTPotion.Response{status_code: status_code, body: body}, _deserialize_func) do
    {:error, status_code, body}
  end

  defp headers(auth_data, uri) do
    Keyword.merge([
      "Content-Type": "application/json",
      "Accept": "application/json"
    ], create_auth_headers(auth_data, uri))
  end

  defp create_auth_headers(auth_data, uri) do
    is_https(uri) |> auth_headers(auth_data)
  end

  defp is_https(uri) do
    %URI{scheme: scheme} = URI.parse(uri)
    scheme == "https"
  end

  defp auth_headers(false = _is_https, _auth_data), do: []
  defp auth_headers(true = _is_https, auth_data) do
    authorization_header = create_encoded_auth_headers(auth_data)

    [
      "Ocp-Apim-Subscription-Key": auth_data.app_secret,
      "Authorization": "Basic #{authorization_header}"
    ]
  end

  defp create_encoded_auth_headers(auth_data) do
    "#{auth_data.app_id}:#{auth_data.app_secret}"
    |> Base.encode64
  end

end
