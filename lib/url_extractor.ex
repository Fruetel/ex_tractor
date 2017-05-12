defmodule UrlExtractor do

  @moduledoc false

  require Logger

  def extract_urls(document) do
    Logger.info "Extracting from #{document.url}"
    document.body
    |> Floki.find("body a")
    |> Floki.attribute("href")
    |> make_absolute(document.url)
    |> drop_duplicates
    |> stringify
  end

  defp make_absolute(urls, base) do
    Enum.map(urls, fn rel -> URI.merge(base, rel) end)
  end

  defp stringify(urls) do
    Enum.map(urls, fn url -> URI.to_string(url) end)
  end

  defp drop_duplicates(urls) do
    Enum.uniq(urls)
  end
end
