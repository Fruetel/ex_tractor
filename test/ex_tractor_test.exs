defmodule ExTractorTest do
  use ExUnit.Case
  doctest ExTractor

  test "it starts the required workers" do
    children = Supervisor.which_children(ExTractor.Supervisor)
    assert 1 = Enum.count(children)
  end
end
