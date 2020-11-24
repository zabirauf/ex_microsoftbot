defmodule ExMicrosoftBot.Models.ActivityTest do
  use ExUnit.Case, async: true

  alias ExMicrosoftBot.Models.Activity

  describe ".parse/1" do
    test "parses a map to the right types" do
      {:ok,
       %Activity{
         type: type,
         id: id,
         timestamp: timestamp,
         serviceUrl: serviceUrl,
         channelId: channelId,
         from: from,
         conversation: conversation,
         recipient: recipient,
         textFormat: textFormat,
         attachmentLayout: attachmentLayout,
         membersAdded: membersAdded,
         membersRemoved: membersRemoved,
         reactionsAdded: reactionsAdded,
         reactionsRemoved: reactionsRemoved,
         topicName: topicName,
         historyDisclosed: historyDisclosed,
         locale: locale,
         text: text,
         speak: speak,
         summary: summary,
         attachments: attachments,
         entities: entities,
         channelData: channelData,
         action: action,
         inputHint: inputHint,
         code: code,
         replyToId: replyToId,
         value: value
       }} =
        Activity.parse(%{
          "type" => "message",
          "id" => "1556500798576",
          "timestamp" => "2019-04-29T01:19:58.647Z",
          "serviceUrl" => "https://smba.trafficmanager.net/emea/",
          "channelId" => "msteams",
          "from" => %{"id" => "some:id", "name" => "Some Name"},
          "conversation" => %{
            "isGroup" => true,
            "id" => "another:id",
            "name" => "Things",
            "conversationType" => "channel"
          },
          "recipient" => %{"id" => "someother:id", "name" => "Some Other Name"},
          "textFormat" => "plain",
          "attachmentLayout" => "flat",
          "membersAdded" => [%{"id" => "someother:id", "name" => "Some Other Name"}],
          "membersRemoved" => [%{"id" => "some:id", "name" => "Some Name"}],
          "reactionsAdded" => [%{"type" => "heart"}],
          "reactionsRemoved" => [%{"type" => "heart"}],
          "topicName" => "Potatoes",
          "historyDisclosed" => false,
          "locale" => "en-US",
          "text" => "Hello!",
          "speak" => "This is Microsoft Sam",
          "summary" => "Sam speaks hello",
          "attachments" => [
            %{
              "contentType" => "image/png",
              "contentUrl" => "https://some.site/image.png",
              "name" => "A great picture",
              "thumbnailUrl" => "https://some.site/image-tiny.png"
            }
          ],
          "entities" => [
            %{
              "type" => "type",
              "name" => "name",
              "supportsDisplay" => false
            }
          ],
          "channelData" => %{
            "tenant" => %{
              "id" => "234567890"
            }
          },
          "action" => "engage",
          "inputHint" => "hint hint",
          "code" => "42",
          "replyToId" => "123234345",
          "value" => %{
            "some_text" => "halp",
            "some_number" => 42
          }
        })

      assert type == "message"
      assert id == "1556500798576"
      assert timestamp == "2019-04-29T01:19:58.647Z"
      assert serviceUrl == "https://smba.trafficmanager.net/emea/"
      assert channelId == "msteams"

      assert from == %ExMicrosoftBot.Models.ChannelAccount{
               id: "some:id",
               name: "Some Name"
             }

      assert conversation == %ExMicrosoftBot.Models.ConversationAccount{
               isGroup: true,
               id: "another:id",
               name: "Things",
               conversationType: "channel"
             }

      assert recipient == %ExMicrosoftBot.Models.ChannelAccount{
               id: "someother:id",
               name: "Some Other Name"
             }

      assert textFormat == "plain"
      assert attachmentLayout == "flat"

      assert membersAdded == [
               %ExMicrosoftBot.Models.ChannelAccount{
                 id: "someother:id",
                 name: "Some Other Name"
               }
             ]

      assert membersRemoved == [
               %ExMicrosoftBot.Models.ChannelAccount{
                 id: "some:id",
                 name: "Some Name"
               }
             ]

      assert reactionsAdded == [
               %ExMicrosoftBot.Models.Reaction{
                 type: "heart"
               }
             ]

      assert reactionsRemoved == [
               %ExMicrosoftBot.Models.Reaction{
                 type: "heart"
               }
             ]

      assert topicName == "Potatoes"
      assert historyDisclosed == false
      assert locale == "en-US"
      assert text == "Hello!"
      assert speak == "This is Microsoft Sam"
      assert summary == "Sam speaks hello"

      assert attachments == [
               %ExMicrosoftBot.Models.Attachment{
                 contentType: "image/png",
                 contentUrl: "https://some.site/image.png",
                 name: "A great picture",
                 thumbnailUrl: "https://some.site/image-tiny.png"
               }
             ]

      assert entities == [
               %ExMicrosoftBot.Models.Entity{
                 type: "type",
                 name: "name",
                 supportsDisplay: false
               }
             ]

      assert channelData == %{
               "tenant" => %{
                 "id" => "234567890"
               }
             }

      assert action == "engage"
      assert inputHint == "hint hint"
      assert code == "42"
      assert replyToId == "123234345"

      assert value == %{
               "some_text" => "halp",
               "some_number" => 42
             }
    end

    test "leaves out empty lists" do
      {:ok,
       %Activity{
         membersAdded: membersAdded,
         membersRemoved: membersRemoved,
         reactionsAdded: reactionsAdded,
         reactionsRemoved: reactionsRemoved,
         attachments: attachments,
         entities: entities,
         suggestedActions: suggestedActions
       }} = Activity.parse(%{})

      assert membersAdded == nil
      assert membersRemoved == nil
      assert reactionsAdded == nil
      assert reactionsRemoved == nil
      assert attachments == nil
      assert entities == nil
      assert suggestedActions == nil
    end
  end
end
