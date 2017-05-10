use Mix.Config

config :ex_tractor, Consumer,
  url: System.get_env("RABBITMQ_URL") || "amqp://localhost",
  exchange: System.get_env("INCOMING_EXCHANGE") || "documents",
  routing_key: System.get_env("INCOMING_ROUTING_KEY") || "unprocessed",
  service: System.get_env("SERVICE_NAME") || "ex_tractor"

#     import_config "#{Mix.env}.exs"
