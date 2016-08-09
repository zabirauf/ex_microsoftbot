defmodule ExMicrosoftBot.Client.BotState do
  @moduledoc """
  This module provides the functions to get the state of bot
  """

  import ExMicrosoftBot.Client, only: [headers: 2, deserialize_response: 2]
  alias ExMicrosoftBot.Models
  alias ExMicrosoftBot.Client
  alias ExMicrosoftBot.TokenManager


  @doc """
  Delete all data for a user in a channel. [API Reference](https://docs.botframework.com/en-us/restapi/state/#!/BotState/BotState_DeleteStateForUser)
  """
  @spec delete_user_data(String.t, String.t, String.t) :: {:ok, [String.t]} | Client.error_type
  def delete_user_data(service_url, channel_id, user_id) do
    api_endpoint = "#{botstate_endpoint(service_url)}/#{channel_id}/users/#{user_id}"

    HTTPotion.delete(api_endpoint, [headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&(Poison.decode!(&1)))
  end

  @doc """
  Get a bots data for the user across all conversations. [API Reference](https://docs.botframework.com/en-us/restapi/state/#!/BotState/BotState_GetUserData)
  """
  @spec get_user_data(String.t, String.t, String.t) :: {:ok, Models.BotData.t} | Client.error_type
  def get_user_data(service_url, channel_id, user_id) do
    api_endpoint = "#{botstate_endpoint(service_url)}/#{channel_id}/users/#{user_id}"

    HTTPotion.get(api_endpoint, [headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Update the bot's data for a user. [API Reference](https://docs.botframework.com/en-us/restapi/state/#!/BotState/BotState_SetUserData)
  """
  @spec set_user_data(String.t, String.t, String.t, BotData.t) :: {:ok, Models.BotData.t} | Client.error_type
  def set_user_data(service_url, channel_id, user_id, %Models.BotData{} = data) do
    api_endpoint = "#{botstate_endpoint(service_url)}/#{channel_id}/users/#{user_id}"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(data), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Get the bots data for all users in a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/state/#!/BotState/BotState_GetConversationData)
  """
  @spec get_conversation_data(String.t, String.t, String.t) :: {:ok, Models.BotData.t} | Client.error_type
  def get_conversation_data(service_url, channel_id, conversation_id) do
    api_endpoint = "#{botstate_endpoint(service_url)}/#{channel_id}/conversations/#{conversation_id}"

    HTTPotion.get(api_endpoint, [headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Update the bot's data for all users in a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/state/#!/BotState/BotState_SetConversationData)
  """
  @spec set_conversation_data(String.t, String.t, String.t, Models.BotData.t) :: {:ok, Models.BotData.t} | Client.error_type
  def set_conversation_data(service_url, channel_id, conversation_id, %Models.BotData{} = data) do
    api_endpoint = "#{botstate_endpoint(service_url)}/#{channel_id}/conversations/#{conversation_id}"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(data), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Get bot's data for a single user in a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/state/#!/BotState/BotState_GetPrivateConversationData)
  """
  @spec get_private_conversation_data(String.t, String.t, String.t, String.t) :: {:ok, Models.BotData.t} | Client.error_type
  def get_private_conversation_data(service_url, channel_id, conversation_id, user_id) do
    api_endpoint = "#{botstate_endpoint(service_url)}/#{channel_id}/conversations/#{conversation_id}/users/#{user_id}"

    HTTPotion.get(api_endpoint, [headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  @doc """
  Update the bot's data for a single user in a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/state/#!/BotState/BotState_SetPrivateConversationData)
  """
  @spec set_user_data_in_conversation(String.t, String.t, String.t, String.t, Models.BotData.t) :: {:ok, Models.BotData.t} | Client.error_type
  def set_user_data_in_conversation(service_url, channel_id, conversation_id, user_id, %Models.BotData{} = data) do
    api_endpoint = "#{botstate_endpoint(service_url)}/#{channel_id}/conversations/#{conversation_id}/users/#{user_id}"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(data), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.BotData.parse/1)
  end

  defp botstate_endpoint(service_url) do
    "#{service_url}/v3/botstate"
  end
end
