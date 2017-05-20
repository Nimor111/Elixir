defmodule Account do

  # Client
  def new(balance \\ 0) do
    fun = fn() -> loop(balance) end

    spawn(fun)
  end

  def deposit(account, amount) do
    send(account, {:deposit, amount})
  end

  def withdraw(account, amount) do
    send(account, {:withdraw, amount})
  end
  
  # sends it to parent process
  def balance(account) do
    send(account, {:balance, self()})

    receive do
      {:balance, balance} -> balance
    end
  end
  
  # Server
  def loop(balance) do
    receive do
      {:deposit, amount} ->
        loop(balance + amount)
      {:withdraw, amount} ->
        loop(balance - amount)
      {:balance, parent} ->
        send(parent, {:balance, balance})
        loop(balance)
    end
  end
end
