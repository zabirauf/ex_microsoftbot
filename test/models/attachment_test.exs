defmodule ExMicrosoftBot.Models.AttachmentTest do
  use ExUnit.Case

  alias ExMicrosoftBot.Models.Attachment

  describe ".parse/1" do
    test "parses a map with string content into the right types" do
      {:ok, %Attachment{
        contentType: contentType,
        content: content,
        name: name
      }} = Attachment.parse(%{
        "contentType" => "text/html",
        "content" => "<div></div>",
        "name" => "something"
      })

      assert contentType == "text/html"
      assert content == "<div></div>"
      assert name == "something"
    end

    test "parses a map with object content into the right types" do
      {:ok, %Attachment{
        contentType: contentType,
        content: content,
        name: name
      }} = Attachment.parse(%{
        "contentType" => "application/vnd.microsoft.card.hero",
        "content" => %{
          "subtitle" => "what a hero!",
          "how_much" => 42,
          "really" => false
        },
        "name" => "something else"
      })

      assert contentType == "application/vnd.microsoft.card.hero"
      assert content == %{
        "subtitle" => "what a hero!",
        "how_much" => 42,
        "really" => false
      }
      assert name == "something else"
    end
  end
end
