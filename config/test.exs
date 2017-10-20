use Mix.Config

config :ex_tractor, Consumer,
  rabbitmq_url: "amqp://guest:guest@localhost"

config :ex_tractor, Publisher,
  rabbitmq_url: "amqp://guest:guest@localhost"
