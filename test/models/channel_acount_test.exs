defmodule ExMicrosoftBot.Models.ChannelAcountTest do
  use ExUnit.Case

  alias ExMicrosoftBot.Models.ChannelAccount

  describe ".parse/1" do
    test "parses a map into the right struct" do
      {:ok, %ChannelAccount{} = channel_account} =
        ChannelAccount.parse(%{
          "id" => "123456789",
          "name" => "Some Name",
          "aadObjectId" => "00000000-0000-0000-0000-000000000000",
          "objectId" => "a53d7526-d0e9-436f-9443-ddb317ef3608",
          "givenName" => "Some",
          "surname" => "Name",
          "email" => "some.name@gmail.com",
          "userPrincipalName" => "some.name@some-app.onmicrosoft.com",
          "tenantId" => "a53d7526-d0e9-436f-9443-ddb317ef3608"
        })

      assert channel_account.id == "123456789"
      assert channel_account.name == "Some Name"
      assert aad_object_id == "00000000-0000-0000-0000-000000000000"
      assert channel_account.objectId == "a53d7526-d0e9-436f-9443-ddb317ef3608"
      assert channel_account.givenName == "Some"
      assert channel_account.surname == "Name"
      assert channel_account.email == "some.name@gmail.com"
      assert channel_account.userPrincipalName == "some.name@some-app.onmicrosoft.com"
      assert channel_account.tenantId == "a53d7526-d0e9-436f-9443-ddb317ef3608"
    end

    test "parses a list into an array of the right struct" do
      {:ok, result} =
        ChannelAccount.parse([
          %{
            "id" => "123456789",
            "name" => "Some Name",
            "aadObjectId" => "00000000-0000-0000-0000-000000000000"
          },
          %{
            "id" => "987654321",
            "name" => "Some Other Name",
            "aadObjectId" => "11111111-1111-1111-1111-111111111111"
          }
        ])

      [
        %ChannelAccount{id: id_a, name: name_a, aadObjectId: aad_object_id_a},
        %ChannelAccount{id: id_b, name: name_b, aadObjectId: aad_object_id_b}
      ] = result

      assert id_a == "123456789"
      assert name_a == "Some Name"
      assert aad_object_id_a == "00000000-0000-0000-0000-000000000000"

      assert id_b == "987654321"
      assert name_b == "Some Other Name"
      assert aad_object_id_b == "11111111-1111-1111-1111-111111111111"
    end

    test "parses a JSON encoded object" do
      %ChannelAccount{id: id, name: name} =
        ChannelAccount.parse("{\"id\":\"123456789\",\"name\":\"Some Name\"}")

      assert id == "123456789"
      assert name == "Some Name"
    end

    test "parses a JSON encoded array of objects" do
      result =
        ChannelAccount.parse(
          "[{\"id\":\"123456789\",\"name\":\"Some Name\",\"aadObjectId\":\"00000000-0000-0000-0000-000000000000\"}," <>
            "{\"id\":\"987654321\",\"name\":\"Some Other Name\",\"aadObjectId\":\"11111111-1111-1111-1111-111111111111\"}]"
        )

      [
        %ChannelAccount{id: id_a, name: name_a, aadObjectId: aad_object_id_a},
        %ChannelAccount{id: id_b, name: name_b, aadObjectId: aad_object_id_b}
      ] = result

      assert id_a == "123456789"
      assert name_a == "Some Name"
      assert aad_object_id_a == "00000000-0000-0000-0000-000000000000"

      assert id_b == "987654321"
      assert name_b == "Some Other Name"
      assert aad_object_id_b == "11111111-1111-1111-1111-111111111111"
    end
  end
end
