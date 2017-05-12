defmodule RetrieverTest do
  use ExUnit.Case

  test "It extracts links" do
    document = %Document{
      url: "http://www.example.com",
      status_code: 200,
      headers: %{"content-type" => "text/html"},
      body: "<html><head></head><body>" <>
        "<a href=\"/test.html\">Link 1</a>" <>
        "<a href=\"http://www.example.org/test2.html\">Link 2</a>" <>
        "<a href=\"http://www.example.org/test2.html\">Link 3</a>" <>
        "</body></html>"
    }

    expected_result = [
      "http://www.example.com/test.html",
      "http://www.example.org/test2.html"
    ]

    assert expected_result == UrlExtractor.extract_urls(document)
  end
end
