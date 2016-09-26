defmodule Mix.Tasks.Benchmark do
  use Mix.Task
  use Mix.Config

  @shortdoc "Writes random events to Riemann"

  def run(_) do
    Mix.Task.run "app.start"
    send_riemann(1_000_000)
  end

  defp send_riemann(n) when n <= 1 do
    create_event |> Riemann.send
  end

  defp send_riemann(n) do
    create_event |> Riemann.send
    send_riemann(n-1)
  end

  defp create_event do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :rand.seed(:exs1024, {a,b,c})
    [service: "CPU utilization", metric: :rand.uniform, attributes: [cpu_number: "1"]]   
  end
end