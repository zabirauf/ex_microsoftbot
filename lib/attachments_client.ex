defmodule ExMicrosoftBot.Client.Attachments do
  @moduledoc """
  This module provides the functions to get information related to attachments.
  """

  import ExMicrosoftBot.Client, only: [headers: 2, deserialize_response: 2]
  alias ExMicrosoftBot.Models, as: Models
  alias ExMicrosoftBot.Client
  alias ExMicrosoftBot.TokenManager

  @endpoint "https://api.botframework.com"

  @doc """
  Get AttachmentInfo structure describing the attachment views. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Attachments/Attachments_GetAttachmentInfo)
  """
  @spec get_attachment(String.t) :: {:ok, Models.AttachmentInfo.t} | Client.error_type
  def get_attachment(attachment_id) do
    api_endpoint = "#{@endpoint}/v3/attachments/#{attachment_id}"

    HTTPotion.get(api_endpoint, [headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&Models.AttachmentInfo.parse/1)
  end

  @doc """
  Get the named view as binary content. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Attachments/Attachments_GetAttachment)
  """
  @spec get_attachment_view(String.t, String.t) :: {:ok, binary} | Client.error_type
  def get_attachment_view(attachment_id, view_id) do
    api_endpoint = "#{@endpoint}/v3/attachments/#{attachment_id}/views/#{view_id}"

    HTTPotion.get(api_endpoint, [headers: headers(TokenManager.get_token, api_endpoint)])
    |> deserialize_response(&(&1)) # Return the body as is because it is binary
  end
end
