defmodule ExMicrosoftBot.Client.Conversations do
  @moduledoc """
  This module provides the functions for conversations
  """

  import ExMicrosoftBot.Client, only: [headers: 2, deserialize_response: 2]
  alias ExMicrosoftBot.Models, as: Models
  alias ExMicrosoftBot.Client
  alias ExMicrosoftBot.TokenManager

  @doc """
  Create a new Conversation. [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#conversation-object)
  """
  @spec create_conversation(String.t, Models.ConversationParameters.t) :: {:ok, Models.ResourceResponse.t} | Client.error_type
  def create_conversation(service_url, %Models.ConversationParameters{} = params) do

    endpoint = conversations_endpoint(service_url)

    HTTPotion.post(endpoint, [body: Poison.encode!(params), headers: headers(TokenManager.get_token, endpoint)])
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end


  @doc """
  This method allows you to send an activity to a conversation regardless of previous posts to a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_SendToConversation)
  """
  @spec send_to_conversation(String.t, Models.Activity.t) :: :ok | Client.error_type
  def send_to_conversation(conversation_id, %Models.Activity{serviceUrl: service_url} = activity), do: send_to_conversation(service_url, conversation_id, activity)

  @doc """
  This method allows you to send an activity to a conversation regardless of previous posts to a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_SendToConversation)
  """
  @spec send_to_conversation(String.t, String.t, Models.Activity.t) :: :ok | Client.error_type
  def send_to_conversation(service_url, conversation_id, %Models.Activity{} = activity) do
    api_endpoint = "#{conversations_endpoint(service_url)}/#{conversation_id}/activities"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(activity), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&(&1))
    |> change_deserialized_response_to_ok
  end


  @doc """
  This method allows you to reply to an activity. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_ReplyToActivity)
  """
  @spec reply_to_activity(String.t, String.t, Models.Activity.t) :: :ok | Client.error_type
  def reply_to_activity(conversation_id, activity_id, %Models.Activity{serviceUrl: service_url} = activity), do: reply_to_activity(service_url, conversation_id, activity_id, activity)

  @doc """
  This method allows you to reply to an activity. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_ReplyToActivity)
  """
  @spec reply_to_activity(String.t, String.t, String.t, Models.Activity.t) :: :ok | Client.error_type
  def reply_to_activity(service_url, conversation_id, activity_id, %Models.Activity{} = activity) do
    api_endpoint = "#{conversations_endpoint(service_url)}/#{conversation_id}/activities/#{activity_id}"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(activity), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&(&1))
    |> change_deserialized_response_to_ok
  end

  @doc """
  This method allows you to update an activity. [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#update-activity)
  """
  @spec update_activity(String.t, String.t, String.t, Models.Activity.t) :: :ok | Client.error_type
  def update_activity(service_url, conversation_id, activity_id, %Models.Activity{} = activity) do
    api_endpoint = "#{conversations_endpoint(service_url)}/#{conversation_id}/activities/#{activity_id}"

    HTTPotion.put(api_endpoint, [body: Poison.encode!(activity), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&(&1))
    |> change_deserialized_response_to_ok
  end


  @doc """
  This function takes a ConversationId and returns an array of ChannelAccount[] objects which are the members of the conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_GetConversationMembers).
  When ActivityId is passed in then it returns the members of the particular activity in the conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_GetActivityMembers)
  """
  @spec get_members(String.t, String.t, String.t) :: {:ok, [Models.ChannelAccount.t]} | Client.error_type
  def get_members(service_url, conversation_id, activity_id \\ nil) do
    api_endpoint = case activity_id do
      nil -> "#{conversations_endpoint(service_url)}/#{conversation_id}/members"
      aid -> "#{conversations_endpoint(service_url)}/#{conversation_id}/activities/#{aid}/members"
    end

    HTTPotion.get(api_endpoint, [headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.ChannelAccount.parse/1)
  end

  @doc """
  This method allows you to upload an attachment directly into a channels blob storage. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_UploadAttachment)
  """
  @spec upload_attachment(String.t, String.t, Models.AttachmentData.t) :: :ok | Client.error_type
  def upload_attachment(service_url, conversation_id, %Models.AttachmentData{} = attachment) do
    api_endpoint = "#{conversations_endpoint(service_url)}/#{conversation_id}/attachments"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(attachment), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  defp change_deserialized_response_to_ok({:ok, _}), do: :ok
  defp change_deserialized_response_to_ok(resp), do: resp

  defp conversations_endpoint(service_url) do
    service_url = String.trim_trailing(service_url, "/")
    "#{service_url}/v3/conversations"
  end
end
