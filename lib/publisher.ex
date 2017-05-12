defmodule Publisher do

  @moduledoc false

  require Logger

  def publish(urls) do
    publish_results = Enum.map(urls, fn url -> publish_url(url) end)
    {:ok, publish_results}
  end

  defp publish_url(url) do
    Logger.info "Publishing url: #{url}"
    Tackle.publish(url, options())
  end

  defp config do
    Application.get_env(:ex_tractor, Publisher)
  end

  defp options do
    %{
      url: config[:url],
      exchange: config[:exchange],
      routing_key: config[:routing_key]
    }
  end
end
