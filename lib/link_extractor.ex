defmodule LinkExtractor do

  @moduledoc false

  require Logger

  def extract_links(document) do
    Logger.info "Extracting from #{document.url}"
    links = document.body
    |> Floki.find("body a")
    |> Floki.attribute("href")
    |> make_absolute(document.url)
    |> remove_fragments
    |> drop_duplicates
    |> linkify(document)

    Logger.info "Extracted #{Enum.count(links)} links"

    urls
  end

  defp make_absolute(urls, base) do
    Enum.map(urls, fn rel -> URI.merge(base, rel) end)
  end

  defp linkify(urls, document) do
    Enum.map(urls, fn url ->
      %Link{
        source_url: document.url,
        destination_url: URI.to_string(url)
      }
    end)
  end

  defp drop_duplicates(urls) do
    Enum.uniq(urls)
  end

  defp remove_fragments(urls) do
    Enum.map(urls, fn url -> Map.put(url, :fragment, nil) end)
  end
end
