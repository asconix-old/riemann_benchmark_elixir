defmodule Mix.Tasks.Benchmark do
  use Mix.Task
  use Mix.Config

  @shortdoc "Writes random events to Riemann"

  def run(_) do
    Mix.Task.run "app.start"
    << a :: 32, b :: 32, c :: 32 >> = :crypto.strong_rand_bytes(12)
    :rand.seed(:exs1024, {a,b,c})
    send_riemann(100_000)
  end

  defp send_riemann(n) do
    Stream.repeatedly(&create_event/0)
    |> Stream.take(n)
    |> Stream.map(&Task.async(fn -> Riemann.send(&1) end))
    |> Stream.run()
  end

  def create_event do
    [service: "CPU utilization",
     metric: :rand.uniform,
     attributes: [cpu_number: "1"]]
  end
end
