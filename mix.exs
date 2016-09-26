defmodule RiemannBenchmarkElixir.Mixfile do
  use Mix.Project

  def project do
    [app: :riemann_benchmark_elixir,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :riemann],
     mod: {RiemannBenchmarkElixir, []}]
  end

  defp deps do
    [{:riemann, "~> 0.0.16"}]
  end
end
