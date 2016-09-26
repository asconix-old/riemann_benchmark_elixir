defmodule RiemannBenchmarkElixir.ElixirRiemannWorker do
  alias RiemannBenchmarkElixir.Counter

  def start_link(n) do
    pid = spawn(fn() -> benchmark(n) end)
    {:ok, pid}
  end

  # https://github.com/koudelka/elixir-riemann
  defp benchmark(n) do
    Stream.repeatedly(&create_event/0)
    |> Stream.take(n)
    |> Stream.map(&Task.async(fn ->
          Riemann.send(&1)
          Counter.inc
        end))
    |> Stream.run()
  end

  def create_event do
    [service: "CPU utilization",
     metric: :rand.uniform,
     attributes: [cpu_number: "1"]]
  end
end
