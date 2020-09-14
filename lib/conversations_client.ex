defmodule ExMicrosoftBot.Client.Conversations do
  @moduledoc """
  This module provides the functions for conversations
  """

  import ExMicrosoftBot.Client,
    only: [authed_req_options: 1, authed_req_options: 2, deserialize_response: 2]

  alias ExMicrosoftBot.Models
  alias ExMicrosoftBot.Client

  @doc """
  Create a new Conversation. [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#conversation-object)
  """
  @spec create_conversation(String.t(), Models.ConversationParameters.t()) ::
          {:ok, Models.ConversationResourceResponse.t()} | Client.error_type()
  def create_conversation(service_url, %Models.ConversationParameters{} = params) do
    endpoint = conversations_endpoint(service_url)

    HTTPotion.post(endpoint, authed_req_options(endpoint, body: Poison.encode!(params)))
    |> deserialize_response(&Models.ConversationResourceResponse.parse/1)
  end

  @doc """
  This method allows you to send an activity to a conversation regardless of previous posts to a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_SendToConversation)
  """
  @spec send_to_conversation(String.t(), Models.Activity.t()) ::
          {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def send_to_conversation(conversation_id, %Models.Activity{serviceUrl: service_url} = activity),
    do: send_to_conversation(service_url, conversation_id, activity)

  @doc """
  This method allows you to send an activity to a conversation regardless of previous posts to a conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_SendToConversation)
  """
  @spec send_to_conversation(String.t(), String.t(), Models.Activity.t()) ::
          {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def send_to_conversation(service_url, conversation_id, %Models.Activity{} = activity) do
    api_endpoint = "#{conversations_endpoint(service_url)}/#{conversation_id}/activities"

    HTTPotion.post(api_endpoint, authed_req_options(api_endpoint, body: Poison.encode!(activity)))
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  This method allows you to reply to an activity. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_ReplyToActivity)
  """
  @spec reply_to_activity(String.t(), String.t(), Models.Activity.t()) ::
          {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def reply_to_activity(
        conversation_id,
        activity_id,
        %Models.Activity{serviceUrl: service_url} = activity
      ),
      do: reply_to_activity(service_url, conversation_id, activity_id, activity)

  @doc """
  This method allows you to reply to an activity. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_ReplyToActivity)
  """
  @spec reply_to_activity(String.t(), String.t(), String.t(), Models.Activity.t()) ::
          {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def reply_to_activity(service_url, conversation_id, activity_id, %Models.Activity{} = activity) do
    api_endpoint =
      "#{conversations_endpoint(service_url)}/#{conversation_id}/activities/#{activity_id}"

    HTTPotion.post(api_endpoint, authed_req_options(api_endpoint, body: Poison.encode!(activity)))
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  This function takes a ConversationId and returns an array of ChannelAccount[] objects which are the members of the conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_GetConversationMembers).
  When ActivityId is passed in then it returns the members of the particular activity in the conversation. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_GetActivityMembers)
  """
  @spec get_members(String.t(), String.t(), String.t()) ::
          {:ok, [Models.ChannelAccount.t()]} | Client.error_type()
  def get_members(service_url, conversation_id, activity_id \\ nil) do
    api_endpoint =
      case activity_id do
        nil ->
          "#{conversations_endpoint(service_url)}/#{conversation_id}/members"

        aid ->
          "#{conversations_endpoint(service_url)}/#{conversation_id}/activities/#{aid}/members"
      end

    HTTPotion.get(api_endpoint, authed_req_options(api_endpoint))
    |> deserialize_response(&Models.ChannelAccount.parse/1)
  end

  @doc """
  This function takes a conversation ID and a member ID and returns a
  ChannelAccount struct for that member of the conversation.

  [API Reference](https://github.com/microsoft/botbuilder-js/blob/5b164105a2f289baaa7b89829e09ddbeda88bfc5/libraries/botframework-connector/src/connectorApi/operations/conversations.ts#L733-L749).
  """
  @spec get_member(String.t(), String.t(), String.t()) ::
          {:ok, Models.ChannelAccount.t()} | Client.error_type()
  def get_member(service_url, conversation_id, member_id) do
    api_endpoint =
      "#{conversations_endpoint(service_url)}/#{conversation_id}/members/#{member_id}"

    HTTPotion.get(api_endpoint, authed_req_options(api_endpoint))
    |> deserialize_response(&Models.ChannelAccount.parse/1)
  end

  @doc """
  This method allows you to upload an attachment directly into a channels blob storage. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_UploadAttachment)
  """
  @spec upload_attachment(String.t(), String.t(), Models.AttachmentData.t()) ::
          {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def upload_attachment(service_url, conversation_id, %Models.AttachmentData{} = attachment) do
    api_endpoint = "#{conversations_endpoint(service_url)}/#{conversation_id}/attachments"

    HTTPotion.post(
      api_endpoint,
      authed_req_options(api_endpoint, body: Poison.encode!(attachment))
    )
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  Updates an existing activity. The activity struct is expected to have an ID. [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#update-activity)
  """
  @spec update_activity(String.t(), String.t(), Models.Activity.t()) ::
          {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def update_activity(service_url, conversation_id, %Models.Activity{id: activity_id} = activity) do
    api_endpoint =
      "#{conversations_endpoint(service_url)}/#{conversation_id}/activities/#{activity_id}"

    api_endpoint
    |> HTTPotion.put(authed_req_options(api_endpoint, body: Poison.encode!(activity)))
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  Deletes an existing activity. The returned content will always be empty.
  [API Reference](https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/update-and-delete-bot-messages?tabs=rest#deleting-messages)
  """
  @spec delete_activity(String.t(), String.t(), Models.Activity.t() | String.t()) ::
          {:ok, binary()} | Client.error_type()
  def delete_activity(service_url, conversation_id, %Models.Activity{id: activity_id}),
    do: delete_activity(service_url, conversation_id, activity_id)

  def delete_activity(service_url, conversation_id, activity_id) do
    api_endpoint =
      "#{conversations_endpoint(service_url)}/#{conversation_id}/activities/#{activity_id}"

    api_endpoint
    |> HTTPotion.delete(authed_req_options(api_endpoint))
    |> deserialize_response(nil)
  end

  defp conversations_endpoint(service_url) do
    service_url = String.trim_trailing(service_url, "/")
    "#{service_url}/v3/conversations"
  end
end
