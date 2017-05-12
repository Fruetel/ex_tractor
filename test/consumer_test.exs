defmodule ConsumerTest do
  use ExUnit.Case, async: false

  import Mock

  test "it handles a message" do
    extracted_urls = [
      "http://www.example.com/page1.html",
      "https://www.example.org/"
    ]

    message = "{\"url\": \"http://example.net/\", \"body\": \"Some Body\"}"

    parsed_message = %Document{
      url: "http://example.net/",
      body: "Some Body"
    }

    with_mock UrlExtractor, [extract_urls: fn _ -> extracted_urls end] do
      with_mock Publisher, [publish: fn _ -> :ok end] do
        assert :ok == Consumer.handle_message(message)
        assert called UrlExtractor.extract_urls(parsed_message)
        assert called Publisher.publish(extracted_urls)
      end
    end
  end
end
