defmodule ClientTestApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :client_test_app,
      version: "0.1.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases do
    [
      "ecto.clean": ["ecto.drop", "ecto.create", "ecto.migrate"],
      "ecto.trunc": ["cmd ../scripts/truncate_tables.sh"],
      x: &x/1
    ]
  end

  defp x(y) do
    IO.inspect(y)

    File.cwd!()
    |> IO.inspect()
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ClientTestApp.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:super_seed, path: "../"},
      {:faker, "~> 0.18"}
    ]
  end
end
