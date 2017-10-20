defmodule ExTractorTest do
  use ExUnit.Case
  doctest ExTractor

  test "it starts the required workers" do
    children = Supervisor.which_children(ExTractor.Supervisor)
    assert 2 = Enum.count(children)
  end
end
