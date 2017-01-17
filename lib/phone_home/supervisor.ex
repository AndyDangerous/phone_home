defmodule PhoneHome.Supervisor do
  use Supervisor

  ## Client API

  def start_link(pools_config) do
    Supervisor.start_link(__MODULE__, pools_config, name: __MODULE__)
  end

  ## Server Callbacks

  def init(pools_config) do
    children = [
      worker(PhoneHome.NoteServer, [self]),
      ]

    opts = [strategy: :one_for_all]

    supervise(children, opts)
  end
end
