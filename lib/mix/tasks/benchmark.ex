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

  defp send_riemann(n) when n <= 1 do
    create_event
    |> Riemann.send
  end

  defp send_riemann(n) do
    create_event
    |> Enum.map(&Task.async(fn -> Riemann.send(&1) end))
    |> Enum.map(&Task.await/1)
    send_riemann(n-1)
  end

  defp create_event do
    [[service: "CPU utilization",
     metric: :rand.uniform,
     attributes: [cpu_number: "1"]]]
  end
end