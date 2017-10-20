defmodule ExTractor do

  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Consumer, []),
      worker(Publisher, [])
    ]

    opts = [strategy: :one_for_one, name: ExTractor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
