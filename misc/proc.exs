defmodule Quitter do
  def run do
    Process.sleep(3000)
    exit(:i_am_tired)
  end
end

Process.flag(:trap_exit, true)

spawn_link(Quitter, :run, [])
receive do msg -> IO.inspect(msg); end
