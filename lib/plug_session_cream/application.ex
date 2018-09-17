defmodule Plug.Session.CREAM.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do

    # Define workers and child supervisors to be supervised
    # children = [
      # Starts a worker by calling: Plug.Session.CREAM.Worker.start_link(arg1, arg2, arg3)
      # worker(Plug.Session.CREAM.Worker, [arg1, arg2, arg3]),
    # ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Plug.Session.CREAM.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  defp children do
    children(Application.get_env(:plug_session_cream, :cache))
  end

  defp children(nil) do
    defmodule Elixir.Plug.Session.CREAM.Cache do
      use Cream.Cluster
    end

    options = Application.get_env(:plug_session_cream, :cream)

    [
      worker(Elixir.Plug.Session.CREAM.Cache, [options])
    ]
  end

  # They specified their own cache which they are presumably supervising.
  defp children(_cache), do: []

end
