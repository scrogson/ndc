defmodule NDC do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(NDC.Repo, []),
      supervisor(NDC.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: NDC.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    NDC.Endpoint.config_change(changed, removed)
    :ok
  end
end
