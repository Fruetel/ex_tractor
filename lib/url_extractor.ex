defmodule UrlExtractor do

  @moduledoc false

  require Logger

  def extract_urls(document) do
    Logger.info "Extracting from #{document.url}"
    document.body
    |> Floki.find("body a")
    |> Floki.attribute("href")
    |> make_absolute(document.url)
  end

  def make_absolute(urls, base) do
    Enum.map(urls, fn rel -> URI.merge(base, rel) |> to_string end)
  end
end
