defmodule ExMicrosoftBot.Client.Conversations do
  @moduledoc """
  This module provides the functions for conversations
  """

  import ExMicrosoftBot.Client,
    only: [deserialize_response: 2, delete: 1, get: 1, post: 2, put: 2]

  alias ExMicrosoftBot.Models
  alias ExMicrosoftBot.Client

  @doc """
  Create a new Conversation.

  @see [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#conversation-object)
  """
  @spec create_conversation(
          service_url :: String.t(),
          params :: Models.ConversationParameters.t()
        ) :: {:ok, Models.ConversationResourceResponse.t()} | Client.error_type()
  def create_conversation(service_url, %Models.ConversationParameters{} = params) do
    service_url
    |> conversations_url()
    |> post(params)
    |> deserialize_response(&Models.ConversationResourceResponse.parse/1)
  end

  @doc """
  This method allows you to send an activity to a conversation regardless of
  previous posts to a conversation.

  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_SendToConversation)
  """
  @spec send_to_conversation(conversation_id :: String.t(), activity :: Models.Activity.t()) ::
          {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def send_to_conversation(conversation_id, %Models.Activity{serviceUrl: service_url} = activity),
    do: send_to_conversation(service_url, conversation_id, activity)

  @doc """
  This method allows you to send an activity to a conversation regardless of
  previous posts to a conversation.

  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_SendToConversation)
  """
  @spec send_to_conversation(
          service_url :: String.t(),
          conversation_id :: String.t(),
          activity :: Models.Activity.t()
        ) :: {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def send_to_conversation(service_url, conversation_id, %Models.Activity{} = activity) do
    service_url
    |> conversations_url("/#{conversation_id}/activities")
    |> post(activity)
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  This method allows you to reply to an activity.
  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_ReplyToActivity)
  """
  @spec reply_to_activity(
          conversation_id :: String.t(),
          activity_id :: String.t(),
          activity :: Models.Activity.t()
        ) :: {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def reply_to_activity(
        conversation_id,
        activity_id,
        %Models.Activity{serviceUrl: service_url} = activity
      ),
      do: reply_to_activity(service_url, conversation_id, activity_id, activity)

  @doc """
  This method allows you to reply to an activity.
  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_ReplyToActivity)
  """
  @spec reply_to_activity(
          service_url :: String.t(),
          conversation_id :: String.t(),
          activity_id :: String.t(),
          activity :: Models.Activity.t()
        ) :: {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def reply_to_activity(service_url, conversation_id, activity_id, %Models.Activity{} = activity) do
    service_url
    |> conversations_url("/#{conversation_id}/activities/#{activity_id}")
    |> post(activity)
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  This function takes a ConversationId and returns an array of ChannelAccount[]
  objects which are the members of the conversation.
  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_GetConversationMembers).

  When ActivityId is passed in then it returns the members of the particular
  activity in the conversation.

  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_GetActivityMembers)
  """
  @spec get_members(
          service_url :: String.t(),
          conversation_id :: String.t(),
          activity_id :: String.t() | nil
        ) :: {:ok, [Models.ChannelAccount.t()]} | Client.error_type()
  def get_members(service_url, conversation_id, activity_id \\ nil) do
    path =
      if activity_id,
        do: "/#{conversation_id}/activities/#{activity_id}/members",
        else: "/#{conversation_id}/members"

    service_url
    |> conversations_url(path)
    |> get()
    |> deserialize_response(&Models.ChannelAccount.parse/1)
  end

  @doc """
  This function takes a conversation ID and a member ID and returns a
  ChannelAccount struct for that member of the conversation.

  @see [API Reference](https://github.com/microsoft/botbuilder-js/blob/5b164105a2f289baaa7b89829e09ddbeda88bfc5/libraries/botframework-connector/src/connectorApi/operations/conversations.ts#L733-L749).
  """
  @spec get_member(
          service_url :: String.t(),
          conversation_id :: String.t(),
          member_id :: String.t()
        ) :: {:ok, Models.ChannelAccount.t()} | Client.error_type()
  def get_member(service_url, conversation_id, member_id) do
    service_url
    |> conversations_url("/#{conversation_id}/members/#{member_id}")
    |> get()
    |> deserialize_response(&Models.ChannelAccount.parse/1)
  end

  @doc """
  This method allows you to upload an attachment directly into a channels blob
  storage.

  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Conversations/Conversations_UploadAttachment)
  """
  @spec upload_attachment(
          service_url :: String.t(),
          conversation_id :: String.t(),
          attachment :: Models.AttachmentData.t()
        ) :: {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def upload_attachment(service_url, conversation_id, %Models.AttachmentData{} = attachment) do
    service_url
    |> conversations_url("/#{conversation_id}/attachments")
    |> post(attachment)
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  Updates an existing activity. The activity struct is expected to have an ID.
  @see [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#update-activity)
  """
  @spec update_activity(
          service_url :: String.t(),
          conversation_id :: String.t(),
          activity :: Models.Activity.t()
        ) :: {:ok, Models.ResourceResponse.t()} | Client.error_type()
  def update_activity(service_url, conversation_id, %Models.Activity{id: activity_id} = activity) do
    service_url
    |> conversations_url("/#{conversation_id}/activities/#{activity_id}")
    |> put(activity)
    |> deserialize_response(&Models.ResourceResponse.parse/1)
  end

  @doc """
  Deletes an existing activity. The returned content will always be empty.
  @see [API Reference](https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/update-and-delete-bot-messages?tabs=rest#deleting-messages)
  """
  @spec delete_activity(
          service_url :: String.t(),
          conversation_id :: String.t(),
          activity_or_id :: Models.Activity.t() | String.t()
        ) :: {:ok, binary()} | Client.error_type()
  def delete_activity(service_url, conversation_id, %Models.Activity{id: activity_id}),
    do: delete_activity(service_url, conversation_id, activity_id)

  def delete_activity(service_url, conversation_id, activity_id) do
    service_url
    |> conversations_url("/#{conversation_id}/activities/#{activity_id}")
    |> delete()
    |> deserialize_response(nil)
  end

  defp conversations_url(service_url) do
    service_url = String.trim_trailing(service_url, "/")
    "#{service_url}/v3/conversations"
  end

  defp conversations_url(service_url, path),
    do: conversations_url(service_url) <> path
end
