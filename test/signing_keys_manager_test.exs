defmodule ExMicrosoftBot.Test.SigningKeysManager do
  use ExUnit.Case
  require Logger
  alias ExMicrosoftBot.SigningKeysManager

  test "Get signing keys from MBF" do
    SigningKeysManager.start_link([])

    {:ok, keys} = SigningKeysManager.get_keys()

    assert length(keys) > 0
    assert [%JOSE.JWK{} | _] = keys
  end

  test "Force refresh signing keys from MBF" do
    SigningKeysManager.start_link([])

    assert :ok = SigningKeysManager.force_refresh_keys()

    {:ok, keys} = SigningKeysManager.get_keys()

    assert length(keys) > 0
    assert [%JOSE.JWK{} | _] = keys
  end
end
