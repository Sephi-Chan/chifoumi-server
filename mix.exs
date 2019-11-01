defmodule Chifoumi.MixProject do
  use Mix.Project

  def project do
    [
      app: :chifoumi,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end


  def application do
    [
      extra_applications: [:logger, :eventstore],
      mod: {Chifoumi, []}
    ]
  end


  defp deps do
    [
      {:jason, "~> 1.1"},
      {:commanded, "~> 1.0.0-rc.0"},
      {:commanded_eventstore_adapter, "~> 1.0.0-rc.0"},
      {:ecto, "~> 3.2"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false}
    ]
  end


  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
