defmodule Metro.Mixfile do
  use Mix.Project

  def project do
    [
      app: :metro,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Metro.Application, []},
      extra_applications: [:logger, :runtime_tools, :coherence]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:ecto_sql, "~> 3.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7", override: true},
      {:coherence, github: "appprova/coherence", ref: "10bb848f885217097ac5be76b202d9bf213b7e20"},
      {:ex_machina, "~> 2.3"},
      {:canary, "~> 1.1.1"},
      {:jason, "~> 1.0"},
      {:businex, "~> 0.2.0"},
      {:scrivener_ecto, "~> 2.2.0"},
      {:scrivener_html, "~> 1.8.1"},
      {:plug_static_ls, "~> 0.6.1"}
#      {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.performance": ["ecto.drop", "ecto.create", "ecto.migrate", "run priv/repo/load.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"],
      "test.reset": ["ecto.drop", "test"]
    ]
  end
end
