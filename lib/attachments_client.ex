defmodule ExMicrosoftBot.Client.Attachments do
  @moduledoc """
  This module provides the functions to get information related to attachments.
  """

  import ExMicrosoftBot.Client, only: [authed_req_options: 1, deserialize_response: 2]
  alias ExMicrosoftBot.Models, as: Models
  alias ExMicrosoftBot.Client

  @doc """
  Get AttachmentInfo structure describing the attachment views. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Attachments/Attachments_GetAttachmentInfo)
  """
  @spec get_attachment(String.t, String.t) :: {:ok, Models.AttachmentInfo.t} | Client.error_type
  def get_attachment(service_url, attachment_id) do
    api_endpoint = "#{attachments_endpoint(service_url)}/#{attachment_id}"

    HTTPotion.get(api_endpoint, authed_req_options(api_endpoint))
    |> deserialize_response(&Models.AttachmentInfo.parse/1)
  end

  @doc """
  Get the named view as binary content. [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Attachments/Attachments_GetAttachment)
  """
  @spec get_attachment_view(String.t, String.t, String.t) :: {:ok, binary} | Client.error_type
  def get_attachment_view(service_url, attachment_id, view_id) do
    api_endpoint = "#{attachments_endpoint(service_url)}/#{attachment_id}/views/#{view_id}"

    HTTPotion.get(api_endpoint, authed_req_options(api_endpoint))
    |> deserialize_response(&(&1)) # Return the body as is because it is binary
  end

  defp attachments_endpoint(service_url) do
    "#{service_url}/v3/attachments"
  end
end
