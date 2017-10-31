defmodule LinkExtractorTest do
  use ExUnit.Case

  test "It extracts links" do
    document = %Document{
      url: "http://www.example.com/some-page",
      status_code: 200,
      headers: %{"content-type" => "text/html"},
      body: "<html><head></head><body>" <>
        "<a href=\"/test.html\">Link 1</a>" <>
        "<img src=\"http://images.example.net/test.jpg\" alt=\"My Image\" />" <>
        "<a href=\"http://www.example.org/test2.html\">Link 2</a>" <>
        "<a href=\"https://www.example.net/path#fragment\">Link 3</a>" <>
        "<a href=\"http://www.example.org/test2.html\">Link 4</a>" <>
        "<a href=\"http://www.example.org/test2.html#fragment\">Link 5</a>" <>
        "</body></html>"
    }

    expected_result = [
      %Link{
        source_url: "http://www.example.com/some-page",
        destination_url: "http://www.example.com/test.html"
      },
      %Link{
        source_url: "http://www.example.com/some-page",
        destination_url: "http://www.example.org/test2.html"
      },
      %Link{
        source_url: "http://www.example.com/some-page",
        destination_url: "https://www.example.net/path"
      },
      %Link{
        source_url: "http://www.example.com/some-page",
        destination_url: "http://images.example.net/test.jpg"
      }
    ]

    assert expected_result == LinkExtractor.extract_links(document)
  end
end
