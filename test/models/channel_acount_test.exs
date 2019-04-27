defmodule ExMicrosoftBot.Models.ChannelAcountTest do
  use ExUnit.Case

  alias ExMicrosoftBot.Models.ChannelAccount

  describe ".parse/1" do
    test "parses a map into the right struct" do
      {:ok, %ChannelAccount{id: id, name: name}} = ChannelAccount.parse(%{
        "id" => "123456789",
        "name" => "Some Name"
      })

      assert id == "123456789"
      assert name == "Some Name"
    end

    test "parses a list into an array of the right struct" do
      {:ok, result} = ChannelAccount.parse([
        %{
          "id" => "123456789",
          "name" => "Some Name"
        },
        %{
          "id" => "987654321",
          "name" => "Some Other Name"
        }
      ])

      [
        %ChannelAccount{id: id_a, name: name_a},
        %ChannelAccount{id: id_b, name: name_b}
      ] = result

      assert id_a == "123456789"
      assert name_a == "Some Name"

      assert id_b == "987654321"
      assert name_b == "Some Other Name"
    end

    test "parses a JSON encoded object" do
      %ChannelAccount{id: id, name: name} =
        ChannelAccount.parse("{\"id\":\"123456789\",\"name\":\"Some Name\"}")

      assert id == "123456789"
      assert name == "Some Name"
    end

    test "parses a JSON encoded array of objects" do
      result = ChannelAccount.parse(
        "[{\"id\":\"123456789\",\"name\":\"Some Name\"}," <>
        "{\"id\":\"987654321\",\"name\":\"Some Other Name\"}]"
      )

      [
        %ChannelAccount{id: id_a, name: name_a},
        %ChannelAccount{id: id_b, name: name_b}
      ] = result

      assert id_a == "123456789"
      assert name_a == "Some Name"

      assert id_b == "987654321"
      assert name_b == "Some Other Name"
    end
  end
end
