defmodule ConsumerTest do
  use ExUnit.Case, async: false

  test "it handles a message" do
    message = :some_message

    assert :ok == Consumer.handle_message(message)
  end
end
