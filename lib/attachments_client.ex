defmodule ExMicrosoftBot.Client.Attachments do
  @moduledoc """
  This module provides the functions to get information related to attachments.
  """

  import ExMicrosoftBot.Client, only: [get: 1, deserialize_response: 2]

  alias ExMicrosoftBot.Models, as: Models
  alias ExMicrosoftBot.Client

  @doc """
  Get AttachmentInfo structure describing the attachment views.
  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Attachments/Attachments_GetAttachmentInfo)
  """
  @spec get_attachment(String.t(), String.t()) ::
          {:ok, Models.AttachmentInfo.t()} | Client.error_type()
  def get_attachment(service_url, attachment_id) do
    service_url
    |> attachments_url("/#{attachment_id}")
    |> get()
    |> deserialize_response(&Models.AttachmentInfo.parse/1)
  end

  @doc """
  Get the named view as binary content.
  @see [API Reference](https://docs.botframework.com/en-us/restapi/connector/#!/Attachments/Attachments_GetAttachment)
  """
  @spec get_attachment_view(String.t(), String.t(), String.t()) ::
          {:ok, String.t()} | Client.error_type()
  def get_attachment_view(service_url, attachment_id, view_id) do
    service_url
    |> attachments_url("/#{attachment_id}/views/#{view_id}")
    |> get()
    |> deserialize_response(& &1)
  end

  defp attachments_url(service_url),
    do: "#{service_url}/v3/attachments"

  defp attachments_url(service_url, path),
    do: attachments_url(service_url) <> path
end
