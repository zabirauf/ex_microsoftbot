defmodule ExMicrosoftBot.Client.Attachments do
  @moduledoc """
  This module provides the functions to get information related to attachments.
  """

  import ExMicrosoftBot.Client, only: [get: 1, deserialize_response: 2]

  alias ExMicrosoftBot.Models, as: Models
  alias ExMicrosoftBot.Client

  @doc """
  Get AttachmentInfo structure describing the attachment views.
  @see [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#get-attachment-information)
  """
  @spec get_attachment(service_url :: String.t(), attachment_id :: String.t()) ::
          {:ok, Models.AttachmentInfo.t()} | Client.error_type()
  def get_attachment(service_url, attachment_id) do
    service_url
    |> attachments_url("/#{attachment_id}")
    |> get()
    |> deserialize_response(&Models.AttachmentInfo.parse/1)
  end

  @doc """
  Get the named view as binary content.
  @see [API Reference](https://docs.microsoft.com/en-us/azure/bot-service/rest-api/bot-framework-rest-connector-api-reference?view=azure-bot-service-4.0#get-attachment)
  """
  @spec get_attachment_view(
          service_url :: String.t(),
          attachment_id :: String.t(),
          view_id :: String.t()
        ) ::
          {:ok, binary()} | Client.error_type()
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
