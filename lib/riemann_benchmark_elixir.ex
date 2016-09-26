defmodule RiemannBenchmarkElixir do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # worker(RiemannBenchmarkElixir.ElixirRiemannWorker, [1_000_000]),
      worker(RiemannBenchmarkElixir.KatjaWorker, [1_000_000]),
      worker(RiemannBenchmarkElixir.Counter, []),
    ]

    opts = [strategy: :one_for_one, name: RiemannBenchmark.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
