defmodule ClientTestAppTest do
  use ExUnit.Case
  doctest ClientTestApp

  test "greets the world" do
    assert ClientTestApp.hello() == :world
  end
end
