defmodule Consumer do

  @moduledoc false

  use Tackle.Consumer,
    url: config[:url],
    exchange: config[:exchange],
    routing_key: config[:routing_key],
    service: config[:service]

  require Logger

  def handle_message(message) do
    Logger.info "Received message: #{message}"

    message
    |> parse_message
    |> UrlExtractor.extract_urls
    |> Publisher.publish
    :ok
  end

  defp config do
    Application.get_env(:ex_tractor, Consumer)
  end

  defp parse_message(message) do
    message |> Poison.decode!(as: %Document{})
  end
end
