use Mix.Config

config :ex_tractor, Consumer,
  rabbitmq_url: System.get_env("RABBITMQ_URL")

config :ex_tractor, Publisher,
  rabbitmq_url: System.get_env("RABBITMQ_URL")
