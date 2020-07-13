defmodule ExMicrosoftBot.Models.ConversationResourceResponseTest do
  use ExUnit.Case, async: true

  alias ExMicrosoftBot.Models.ConversationResourceResponse

  describe ".parse/1" do
    test "parses a map to the right type" do
      assert {:ok,
              %ConversationResourceResponse{
                id: "1556500798576",
                activityId: "1556544498576",
                serviceUrl: "https://smba.trafficmanager.net/emea/"
              }} =
               ConversationResourceResponse.parse(%{
                 "id" => "1556500798576",
                 "activityId" => "1556544498576",
                 "serviceUrl" => "https://smba.trafficmanager.net/emea/"
               })
    end

    test "parses a JSON string to the right type" do
      assert %ConversationResourceResponse{
               id: "1556500798576",
               activityId: "1556544498576",
               serviceUrl: "https://smba.trafficmanager.net/emea/"
             } =
               ConversationResourceResponse.parse(
                 "{\"id\":\"1556500798576\"," <>
                   "\"activityId\":\"1556544498576\"," <>
                   "\"serviceUrl\":\"https://smba.trafficmanager.net/emea/\"}"
               )
    end
  end
end
