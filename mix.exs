defmodule AutoHostMe.MixProject do
  use Mix.Project

  def project do
    [
      app: :auto_host_me,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {AutoHostMe.Application, []}
    ]
  end

  defp deps do
    [
    ]
  end
end
