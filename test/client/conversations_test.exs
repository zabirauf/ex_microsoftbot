defmodule ExMicrosoftBot.Client.ConversationsTest do
  use ExUnit.Case

  import Plug.Conn, only: [fetch_query_params: 1, read_body: 1, resp: 3, get_req_header: 2]

  alias ExMicrosoftBot.Models.{Activity, ChannelAccount, PagedMembersResult, ResourceResponse}
  alias ExMicrosoftBot.Client.Conversations

  @bypass_port Application.fetch_env!(:ex_microsoftbot, Bypass) |> Keyword.fetch!(:port)

  describe "send_to_conversation/3" do
    setup do
      bypass = Bypass.open(port: @bypass_port)
      {:ok, bypass: bypass}
    end

    test "POSTS the activity to the given serviceUrl and returns its resource", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/v3/conversations/42/activities", fn conn ->
        assert conn |> get_req_header("content-type") |> List.first() == "application/json"
        assert conn |> get_req_header("accept") |> List.first() == "application/json"
        assert conn |> get_req_header("authorization") |> List.first() == "Bearer"

        {:ok, body, conn} = read_body(conn)

        assert body ==
                 "{\"value\":null,\"type\":\"text\",\"topicName\":null," <>
                   "\"timestamp\":null,\"textFormat\":null,\"text\":\"ohai\"," <>
                   "\"summary\":null,\"suggestedActions\":null,\"speak\":null," <>
                   "\"serviceUrl\":null,\"replyToId\":null," <>
                   "\"recipient\":{" <>
                   "\"userPrincipalName\":null,\"tenantId\":null,\"surname\":null,\"objectId\":null," <>
                   "\"name\":\"Jonas\",\"id\":55,\"givenName\":null,\"email\":null" <>
                   "},\"reactionsRemoved\":null,\"reactionsAdded\":null," <>
                   "\"membersRemoved\":null,\"membersAdded\":null,\"locale\":null," <>
                   "\"inputHint\":null,\"id\":null,\"historyDisclosed\":null,\"from\":null," <>
                   "\"entities\":null,\"conversation\":null,\"code\":null,\"channelId\":null," <>
                   "\"channelData\":null,\"attachments\":null,\"attachmentLayout\":null," <>
                   "\"action\":null}"

        resp(conn, 200, "{\"id\":\"12345\"}")
      end)

      assert Conversations.send_to_conversation(
               "http://localhost:#{@bypass_port}",
               42,
               %Activity{
                 type: "text",
                 recipient: %ChannelAccount{
                   id: 55,
                   name: "Jonas"
                 },
                 text: "ohai"
               }
             ) == {:ok, %ResourceResponse{id: "12345"}}
    end
  end

  describe "update_activity/3" do
    setup do
      bypass = Bypass.open(port: @bypass_port)
      {:ok, bypass: bypass}
    end

    test "PUTs the activity to the given serviceUrl and returns its resource", %{bypass: bypass} do
      Bypass.expect_once(bypass, "PUT", "/v3/conversations/42/activities/12345", fn conn ->
        assert conn |> get_req_header("content-type") |> List.first() == "application/json"
        assert conn |> get_req_header("accept") |> List.first() == "application/json"
        assert conn |> get_req_header("authorization") |> List.first() == "Bearer"

        {:ok, body, conn} = read_body(conn)

        assert body ==
                 "{\"value\":null,\"type\":\"text\",\"topicName\":null," <>
                   "\"timestamp\":null,\"textFormat\":null,\"text\":\"ohai\"," <>
                   "\"summary\":null,\"suggestedActions\":null,\"speak\":null," <>
                   "\"serviceUrl\":null,\"replyToId\":null," <>
                   "\"recipient\":{" <>
                   "\"userPrincipalName\":null,\"tenantId\":null,\"surname\":null,\"objectId\":null," <>
                   "\"name\":\"Jonas\",\"id\":55,\"givenName\":null,\"email\":null" <>
                   "},\"reactionsRemoved\":null,\"reactionsAdded\":null," <>
                   "\"membersRemoved\":null,\"membersAdded\":null,\"locale\":null," <>
                   "\"inputHint\":null,\"id\":\"12345\",\"historyDisclosed\":null," <>
                   "\"from\":null,\"entities\":null,\"conversation\":null," <>
                   "\"code\":null,\"channelId\":null,\"channelData\":null," <>
                   "\"attachments\":null,\"attachmentLayout\":null,\"action\":null}"

        resp(conn, 200, "{\"id\":\"12345\"}")
      end)

      assert Conversations.update_activity(
               "http://localhost:#{@bypass_port}",
               42,
               %Activity{
                 id: "12345",
                 type: "text",
                 recipient: %ChannelAccount{
                   id: 55,
                   name: "Jonas"
                 },
                 text: "ohai"
               }
             ) == {:ok, %ResourceResponse{id: "12345"}}
    end
  end

  describe "delete_activity/3" do
    setup do
      bypass = Bypass.open(port: @bypass_port)
      {:ok, bypass: bypass}
    end

    test "DELETEs the activity given serviceUrl", %{bypass: bypass} do
      Bypass.expect_once(bypass, "DELETE", "/v3/conversations/42/activities/12345", fn conn ->
        assert conn |> get_req_header("content-type") |> List.first() == "application/json"
        assert conn |> get_req_header("accept") |> List.first() == "application/json"
        assert conn |> get_req_header("authorization") |> List.first() == "Bearer"

        assert {:ok, "", conn} = read_body(conn)

        resp(conn, 200, "")
      end)

      assert Conversations.delete_activity(
               "http://localhost:#{@bypass_port}",
               42,
               %Activity{
                 id: "12345",
                 type: "text",
                 recipient: %ChannelAccount{
                   id: 55,
                   name: "Jonas"
                 },
                 text: "ohai"
               }
             ) == {:ok, ""}
    end
  end

  describe "get_paged_members/3" do
    setup do
      bypass = Bypass.open(port: @bypass_port)
      {:ok, bypass: bypass}
    end

    test "fetches paginated member results", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/v3/conversations/xyz/pagedmembers", fn conn ->
        assert conn |> get_req_header("content-type") |> List.first() == "application/json"
        assert conn |> get_req_header("accept") |> List.first() == "application/json"
        assert conn |> get_req_header("authorization") |> List.first() == "Bearer"

        assert {:ok, "", conn} = read_body(conn)

        response =
          Poison.encode!(%{
            members: [
              %{
                id: "42",
                name: "James",
                surname: "Lindy",
                email: "james@lindy.com"
              }
            ],
            continuationToken: "zzz"
          })

        resp(conn, 200, response)
      end)

      assert {:ok, %PagedMembersResult{members: members, continuationToken: token}} =
               Conversations.get_paged_members("http://localhost:#{@bypass_port}", "xyz")

      assert members == [
               %ChannelAccount{
                 id: "42",
                 name: "James",
                 surname: "Lindy",
                 email: "james@lindy.com",
                 objectId: nil,
                 userPrincipalName: nil,
                 tenantId: nil
               }
             ]

      assert token == "zzz"
    end

    test "accepts pagination args", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/v3/conversations/xyz/pagedmembers", fn conn ->
        assert {:ok, "", conn} = read_body(conn)

        %{query_params: query} = fetch_query_params(conn)

        assert query["pageSize"] == "42"
        assert query["continuationToken"] == "xxx"

        resp(conn, 200, Poison.encode!(%{members: []}))
      end)

      paging = [page_size: 42, continuation_token: "xxx"]

      assert {:ok, %PagedMembersResult{members: [], continuationToken: nil}} =
               Conversations.get_paged_members("http://localhost:#{@bypass_port}", "xyz", paging)
    end
  end
end
