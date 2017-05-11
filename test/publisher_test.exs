defmodule PublisherTest do

  use ExUnit.Case, async: false

  import Mock

  test "It publishes a list of urls" do
    urls = [
      "http://www.example.org",
      "http://www.example.net",
      "http://www.example.net/some_ressource"
    ]

    with_mock Tackle, [publish: fn _, _ -> :ok end] do
      assert {:ok, [:ok, :ok, :ok]} = Publisher.publish(urls)
      assert called Tackle.publish("http://www.example.org", :_)
      assert called Tackle.publish("http://www.example.net", :_)
      assert called Tackle.publish("http://www.example.net/some_ressource", :_)
    end
  end
end
