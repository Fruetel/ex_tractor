defmodule Consumer do

  @moduledoc false

  require Logger

  use GenServer
  use AMQP

  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end

  @exchange    "documents"
  @routing_key "retrieved"
  @queue       "ex_tractor"
  @queue_error "#{@queue}_error"

  def init(_opts) do
    rabbitmq_connect()
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end
  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end
  def handle_info({:DOWN, _, :process, _pid, _reason}, _) do
    {:ok, chan} = rabbitmq_connect()
    {:noreply, chan}
  end

  defp consume(channel, tag, redelivered, payload) do
    Logger.info "Consuming message"
    payload
    |> Poison.decode!(as: %Document{})
    |> LinkExtractor.extract_links

    Basic.ack channel, tag

    rescue _exception ->
    Basic.reject channel, tag, requeue: not redelivered
    Logger.error "Error processing #{payload}"
  end

  defp rabbitmq_connect do
    case Connection.open(Application.get_env(
      :ex_tractor, Consumer)[:rabbitmq_url]
    ) do
      {:ok, conn} ->
        Logger.info "RabbitMq connection established"
        # Get notifications when the connection goes down
        Process.monitor(conn.pid)
        # Everything else remains the same
        {:ok, chan} = Channel.open(conn)
        Basic.qos(chan, prefetch_count: 10)
        Queue.declare(chan, @queue_error, durable: true)
        Queue.declare(chan, @queue, durable: true,
                      arguments: [{"x-dead-letter-exchange", :longstr, ""},
                                  {"x-dead-letter-routing-key", :longstr, @queue_error}])
                                  Exchange.topic(chan, @exchange, durable: true)
                                  Queue.bind(chan, @queue, @exchange,
                                             [routing_key: @routing_key])
                                             {:ok, _consumer_tag} = Basic.consume(chan, @queue)
                                             {:ok, chan}
      {:error, _} ->
        # Reconnection loop
        :timer.sleep(10_000)
        rabbitmq_connect()
    end
  end
end
