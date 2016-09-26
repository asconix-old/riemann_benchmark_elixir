defmodule RiemannBenchmarkElixir do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(RiemannBenchmarkElixir.Worker, [1_000_000]),
      worker(RiemannBenchmarkElixir.Counter, []),
    ]

    opts = [strategy: :one_for_one, name: RiemannBenchmark.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
