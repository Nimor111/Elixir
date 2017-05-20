defmodule GenAccount do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, "Hello")
  end
  
  # called when start_link is called
  # sets initial state of process
  def init(initial_data) do
    greetings = %{:greeting => initial_data}
    {:ok, greetings}
  end
  
  def get_state(pid) do
    GenServer.call(pid, {:get_state})
  end

  def set_state(pid, new_state) do
    GenServer.cast(pid, {:set_state, new_state})
  end
  
  # triggered by GenServer.call
  # from - reference to the caller, would be self here I guess
  def handle_call({:get_state}, _from, state) do
    {:reply, state, state}
  end
  
  # async
  # does not wait for method to finish before executing code below it
  # does not return anything, returns :ok, hopefully xD
  def handle_cast({:set_state, new_state}, state) do
    updated_state = Map.put(state, :greeting, new_state)
    {:noreply, updated_state}
  end
end
