defmodule PublisherTest do

  use ExUnit.Case, async: false

  import Mock

  test "It publishes a list of urls" do
    urls = [
      "http://www.example.org",
      "http://www.example.net",
      "http://www.example.net/some_ressource"
    ]

    expected_messages = [
      "{\"url\":\"http://www.example.org\"}",
      "{\"url\":\"http://www.example.net\"}",
      "{\"url\":\"http://www.example.net/some_ressource\"}"
    ]

    with_mock Tackle, [publish: fn _, _ -> :ok end] do
      assert {:ok, [:ok, :ok, :ok]} = Publisher.publish(urls)
      Enum.map(expected_messages, fn message ->
        assert called Tackle.publish(message, :_)
      end)
    end
  end
end
