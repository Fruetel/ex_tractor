defmodule LinkExtractor do

  @moduledoc false

  require Logger

  def extract_links(%Document{} = document) do
    Logger.info "Extracting from #{document.url}"
    hrefs = extract_hrefs(document.body)
    img_src = extract_img_src(document.body)

    hrefs
    |> Enum.concat(img_src)
    |> make_absolute(document.url)
    |> remove_fragments
    |> drop_duplicates
    |> linkify(document)
    |> publish

  end

  defp extract_hrefs(html) do
    html
    |> Floki.find("body a")
    |> Floki.attribute("href")
  end

  defp extract_img_src(html) do
    html
    |> Floki.find("body img")
    |> Floki.attribute("src")
  end

  defp publish(links) do
    Logger.info "Publishing #{Enum.count(links)} extracted links"
    Enum.map(links, fn link ->
      :ok = Publisher.publish("links", "extracted", link)
    end)
    links
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
