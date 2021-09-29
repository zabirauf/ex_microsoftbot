defmodule ExMicrosoftBot.Client.Teams do
  @moduledoc """
  This module provides functions for Teams (from Microsoft Teams).
  """

  import ExMicrosoftBot.Client, only: [deserialize_response: 2, get: 1]

  alias ExMicrosoftBot.{Client, Models}

  @doc """
  Returns details for the Team with the given ID.

  https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/get-teams-context?tabs=json#get-teams-details
  """
  @spec details(service_url :: String.t(), team_id :: String.t()) ::
          {:ok, Models.Team.t()} | Client.error_type()
  def details(service_url, team_id) do
    service_url
    |> teams_url("/#{team_id}")
    |> get()
    |> deserialize_response(&Models.Team.parse/1)
  end

  @doc """
  Returns all channels in the Team with the given ID.

  https://docs.microsoft.com/en-us/microsoftteams/platform/bots/how-to/get-teams-context?tabs=json#get-the-list-of-channels-in-a-team
  """
  @spec channels(service_url :: String.t(), team_id :: String.t()) ::
          {:ok, Models.ChannelAccount.t()} | Client.error_type()
  def channels(service_url, team_id) do
    service_url
    |> teams_url("/#{team_id}/conversations")
    |> get()
    |> deserialize_response(&Models.Teams.ChannelsResponse.parse/1)
  end

  defp teams_url(service_url) do
    service_url = String.trim_trailing(service_url, "/")
    "#{service_url}/v3/teams"
  end

  defp teams_url(service_url, path),
    do: teams_url(service_url) <> path
end
