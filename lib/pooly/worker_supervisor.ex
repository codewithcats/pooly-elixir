defmodule Pooly.WorkerSupervisor do
  use Supervisor

  # APIs
  def start_link(mfa) do
    Supervisor.start_link(__MODULE__, mfa)
  end

  # Callbacks
  def init({m, f, a}) do
    worker_opts = [
      restart: :permanent,
      function: f
    ]
    # Supervisor.Spec.worker/3
    # Use to create "child specification"
    # Note: Supervisor.Spec is imported by default
    # This supervisor has one child, or "one kind" of child
    children = [worker(m, a, worker_opts)]
    opts = [
      # The Supervisor initially starts out with empty workers
      # Workers are then dynamically attached to the Supervisor
      strategy: :simple_one_for_one,
      max_restarts: 5,
      max_seconds: 5
    ]
    # The return value of the init/1 callback
    # must be a supervisor specification.
    supervise(children, opts)
  end
end

