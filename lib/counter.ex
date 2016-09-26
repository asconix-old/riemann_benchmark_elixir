defmodule RiemannBenchmarkElixir.Counter do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def inc do
    GenServer.cast(__MODULE__, :inc)
  end

  def init(_args) do
    now = :erlang.system_time(1)
    :timer.send_interval(5000, :print)
    {:ok, {1, now}}
  end

  def handle_cast(:inc, {count, start}) do
    {:noreply, {count + 1, start}}
  end

  def handle_info(:print, {count, start} = state) do
    now = :erlang.system_time(1)
    runtime = now - start
    IO.puts("avg: #{count / runtime}")
    {:noreply, state}
  end
end
