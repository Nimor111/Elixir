defmodule Quitter do
  def run do
    Process.sleep(3000)
    exit(:i_am_tired)
  end
end

pid = spawn_link(Quitter, :run, [])
