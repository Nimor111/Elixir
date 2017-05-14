# nil and false are falsy, everything else is truthy
if_else = fn
  nil, _, n -> n
  false, _, n -> n
  _, y, _ -> y
end

if_else_lazy = fn 
  nil, _, f2 -> f2.()
  false, _, f2 -> f2.()
  _, f1, _ -> f1.()
end

IO.puts(if_else.(true, "yes", "no"))
IO.puts(if_else.(:true, "yes", "no"))
IO.puts(if_else.(:false, "yes", "no"))
IO.puts(if_else.(nil, "yes", "no"))
IO.puts(if_else.([], "yes", "no"))
IO.puts(if_else.(5, "yes", "no"))
IO.puts(if_else.("", "yes", "no"))

truth = fn() ->
  IO.puts("You are right.")
  "yes"
end

lie = fn() ->
  IO.puts("You are lying to me!")
  "no"
end

IO.puts(if_else_lazy.(:true, truth, lie))
IO.puts(if_else_lazy.(false, truth, lie))
