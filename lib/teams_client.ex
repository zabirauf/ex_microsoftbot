defmodule ExMicrosoftBot.Client.Teams do
  @moduledoc """
  This module provides functions for Teams (from Microsoft Teams).
  """

  import ExMicrosoftBot.Client,
    only: [get: 2, authed_req_options: 1, deserialize_response: 2]

  alias ExMicrosoftBot.{Client, Models}

  @doc """
  Returns details for the Team with the given ID.

  https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/get-teams-context?tabs=json#get-teams-details
  """
  @spec details(String.t(), String.t()) :: {:ok, Models.Team.t()} | Client.error_type()
  def details(service_url, team_id) do
    api_endpoint = "#{teams_endpoint(service_url)}/#{team_id}"

    get(api_endpoint, authed_req_options(api_endpoint))
    |> deserialize_response(&Models.Team.parse/1)
  end

  @doc """
  Returns all channels in the Team with the given ID.

  https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/get-teams-context?tabs=json#get-the-list-of-channels-in-a-team
  """
  @spec channels(String.t(), String.t()) :: {:ok, Models.ChannelAccount.t()} | Client.error_type()
  def channels(service_url, team_id) do
    api_endpoint = "#{teams_endpoint(service_url)}/#{team_id}/conversations"

    get(api_endpoint, authed_req_options(api_endpoint))
    |> deserialize_response(&Models.Teams.ChannelsResponse.parse/1)
  end

  defp teams_endpoint(service_url) do
    service_url = String.trim_trailing(service_url, "/")
    "#{service_url}/v3/teams"
  end
end
