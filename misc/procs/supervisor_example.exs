# useful methods
# {:ok, super_pid} = SupervisorExample.start_link
# [one] = Supervisor.which_children(super_pid)
# {_, pid, _, _} = one - get pid of supervised process
# strategies: 
# :one_for_one - restarts only current stopped process
# :one_for_all - restarts all worker processes
# :rest_for_one - restarts all worker processes defined below the stopped one
#
# special shit
# :simple_one_for_one - worker is not started with supervisor, have to call Supervisor.start_child
# Supervisor.terminate_child(super_pid, pid) to stop child
# can be used for unique sessions

defmodule SupervisorExample do
  use Supervisor
  Code.load_file("package_receiver.exs", ".")

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(PackageReceiver, [])
    ]
  
    supervise(children, strategy: :one_for_one)
  end
end
