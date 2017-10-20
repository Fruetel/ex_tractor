defmodule ExTractor.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_tractor,
     version: "0.1.0",
     elixir: "~> 1.5",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger],
     mod: {ExTractor, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:amqp, "1.0.0-pre.2"},
    {:credo, "~> 0.7", only: :dev},
    {:floki, "~> 0.17"},
    {:poison, "~> 3.0"},
    {:mock, "~> 0.2", only: :test}]
  end
end
