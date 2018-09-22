defmodule AutoHostMeTest do
  use ExUnit.Case
  doctest AutoHostMe

  test "greets the world" do
    assert AutoHostMe.hello() == :world
  end
end
