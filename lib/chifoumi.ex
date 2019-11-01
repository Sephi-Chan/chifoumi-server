defmodule Chifoumi do
  use Application

  def start(_type, _args) do
    children = [Chifoumi.Application]
    opts = [strategy: :one_for_one, name: Chifoumi.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
