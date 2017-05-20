defmodule PackageReceiver do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def leave_at_the_door(receiver_pid, package_name) do
    GenServer.cast(receiver_pid, {:async_package, package_name})
  end

  def handle_cast({:async_package, package_name}, state) do
    :timer.sleep(1000)
    IO.puts "I received package: #{package_name}"
    {:noreply, state}
  end
end
