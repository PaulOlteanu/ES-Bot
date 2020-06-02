defmodule EmoteStoreTest do
  use ExUnit.Case
  doctest EmoteStore

  test "greets the world" do
    assert EmoteStore.hello() == :world
  end
end
