defmodule Jacklexer do
  use Application

  def start(_type, _args) do
    Jacklexer.Supervisor.start_link(name: Jacklexer.Supervisor)
  end
end

defmodule Jacklexer.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [

    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
