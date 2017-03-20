defmodule CitizenAdvocateNotifier.Mixfile do
  use Mix.Project

  def project do
    [app: :citizen_advocate_notifier,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     elixirc_paths: elixirc_paths(Mix.env),
     lockfile: "../../mix.lock",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :ex_twilio],
     mod: {CitizenAdvocateNotifier.Application, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # To depend on another app inside the umbrella:
  #
  #   {:my_app, in_umbrella: true}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_twilio, "~> 0.3.0"}
    ]
  end

  # tried to have .exs mocks, but they were not getting compiled in time,
  # so resorted to suggestion here:
  # https://medium.com/perplexinomicon-of-philosodad/mock-modules-and-where-to-find-them-319ae74c088b#.jmlpyku9a
  defp elixirc_paths(:test) do
    ["lib", "test/mocks"]
  end

  defp elixirc_paths(_), do: ["lib"]
end
