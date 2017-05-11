use Mix.Config

config :ex_tractor, Consumer,
  url: System.get_env("RABBITMQ_URL") || "amqp://localhost",
  exchange: System.get_env("INCOMING_EXCHANGE") || "documents",
  routing_key: System.get_env("INCOMING_ROUTING_KEY") || "unprocessed",
  service: System.get_env("SERVICE_NAME") || "ex_tractor"

config :ex_tractor, Publisher,
  url: System.get_env("RABBITMQ_URL") || "amqp://localhost",
  exchange: System.get_env("OUTGOING_EXCHANGE") || "urls",
  routing_key: System.get_env("OUTGOING_ROUTING_KEY") || "extracted"

#     import_config "#{Mix.env}.exs"
