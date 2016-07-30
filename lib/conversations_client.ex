defmodule ExMicrosoftBot.Client.Conversations do
  @moduledoc """
  This module provides the functions for conversations
  """

  import ExMicrosoftBot.Client, only: [headers: 2, deserialize_response: 2]
  alias ExMicrosoftBot.Models, as: Models
  alias ExMicrosoftBot.Client
  alias ExMicrosoftBot.TokenManager

  @endpoint "https://api.botframework.com"
  @conversations_endpoint "#{@endpoint}/v3/conversations"

  @doc """
  Create a new Conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_CreateConversation)
  """
  @spec create_conversation(Models.ConversationParameters.t) :: {:ok, Models.ResourceResponse.t} | Client.error_type
  def create_conversation(%Models.ConversationParameters{} = params) do

    HTTPotion.post(@conversations_endpoint, [body: Poison.encode!(params), headers: headers(TokenManager.get_token, @conversations_endpoint)])
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  This method allows you to send an activity to a conversation regardless of previous posts to a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_SendToConversation)
  """
  @spec send_to_conversation(String.t, Models.Activity.t) :: :ok | Client.error_type
  def send_to_conversation(conversation_id, %Models.Activity{} = activity) do
    api_endpoint = "#{@conversations_endpoint}/#{conversation_id}/activities"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(activity), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&(&1))
    |> change_deserialized_response_to_ok
  end

  @doc """
  This method allows you to reply to an activity. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_ReplyToActivity)
  """
  @spec reply_to_activity(String.t, String.t, Models.Activity.t) :: :ok | Client.error_type
  def reply_to_activity(conversation_id, activity_id, %Models.Activity{} = activity) do
    api_endpoint = "#{@conversations_endpoint}/#{conversation_id}/activities/#{activity_id}"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(activity), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&(&1))
    |> change_deserialized_response_to_ok
  end

  @doc """
  This function takes a ConversationId and returns an array of ChannelAccount[] objects which are the members of the conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_GetConversationMembers).
  When ActivityId is passed in then it returns the members of the particular activity in the conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_GetActivityMembers)
  """
  @spec get_members(String.t) :: {:ok, [Models.ChannelAccount.t]} | Client.error_type
  def get_members(conversation_id, activity_id \\ nil) do
    api_endpoint = case activity_id do
      nil -> "#{@conversations_endpoint}/#{conversation_id}/members"
      aid -> "#{@conversations_endpoint}/#{conversation_id}/activities/#{aid}/members"
    end

    HTTPotion.get(api_endpoint, [headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(Models.ChannelAccount.parse/1) # TODO: Check if this works as it is an array
  end

  @doc """
  This method allows you to upload an attachment directly into a channels blob storage. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_UploadAttachment)
  """
  @spec upload_attachment(String.t, Models.AttachmentData.t) :: :ok | Client.error_type
  def upload_attachment(conversation_id, %Models.AttachmentData{} = attachment) do
    api_endpoint = "#{@conversations_endpoint}/#{conversation_id}/attachments"

    HTTPotion.post(api_endpoint, [body: Poison.encode!(attachment), headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  defp change_deserialized_response_to_ok({:ok, _}), do: :ok
  defp change_deserialized_response_to_ok(resp), do: resp
end
