defmodule SenderModule do
  Code.load_file("package_receiver.exs", ".")

  packages = ["Book", "Bat", "Broom", "Bananas"]
  {:ok, pid} = PackageReceiver.start_link

  Enum.each(packages, fn package ->
    IO.puts "Delivering package: #{package}"
    PackageReceiver.leave_at_the_door(pid, package)
  end)

  IO.puts "ALL DONE"
  IO.puts "_____________"
end
