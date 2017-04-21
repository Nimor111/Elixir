defmodule Sequence do
  @enforce_keys [:state, :generator]
  defstruct [:state, :generator]
  
  def generate(%Sequence{state: {nil, 'l', _, _, _, 0}, generator: _}),
    do: nil
  def generate(%Sequence{state: {s, 'l', limit, start, limit, 0}, generator: gen}),
    do: {s, %Sequence{state: {nil, 'l', limit, start, limit, 0}, generator: gen}}
  def generate(%Sequence{state: {s, 'l', 1, 'c', start, limit}, generator: gen}),
    do: {s, %Sequence{state: {start, 'l', limit, 'c', start, limit}, generator: gen}}
  def generate(%Sequence{state: {s, 'l', 1, start, limit, n}, generator: gen}) do
    {s, %Sequence{state: {start, 'l', limit, start, limit, n - 1}, generator: gen}}
  end
  def generate(%Sequence{state: {s, 'l', n, 'c', start, limit}, generator: gen}),
    do: {s, %Sequence{state: {gen.(s) |> elem(1), 'l', n - 1, 'c', start, limit},
                      generator: gen}}
  def generate(%Sequence{state: {s, 'l', l, start, limit, n}, generator: gen}) do
    {s, %Sequence{state: {gen.(s) |> elem(1), 'l', l - 1, start, limit, n}, generator: gen}}
  end
  def generate(%Sequence{state: {nil, 'c', start}, generator: gen}),
    do: {start, %Sequence{state: {start, 'c', start}, generator: gen}}
  def generate(%Sequence{state: {start=s, 'c', start}, generator: gen}),
    do: {s, %Sequence{state: {gen.(s) |> elem(1), 'c', start}, generator: gen}}
  def generate(%Sequence{state: {s, 'c', start}, generator: gen}),
    do: {s, %Sequence{state: {gen.(s) |> elem(1), 'c', start}, generator: gen}}
  def generate(%Sequence{state: {nil, 'l', _}, generator: _}), do: nil 
  def generate(%Sequence{state: {_, 'l', 0}, generator: _}), do: nil
  def generate(%Sequence{state: {s, 'l', n}, generator: gen}),
    do: {s, %Sequence{state: {gen.(s) |> elem(1), 'l', n - 1}, generator: gen}}
  def generate(%Sequence{state: nil, generator: _}), do: nil
  def generate(seq) do
    {seq.state, %Sequence{state: seq.generator.(seq.state) |> elem(1),
                          generator: seq.generator}}
  end
  
  def generate_value(%Sequence{state: nil, generator: _}),
    do: raise FunctionClauseError
  def generate_value(%Sequence{state: {_, 'c', _}, generator: _}=seq),
    do: (seq |> Sequence.generate) |> elem(0)
  def generate_value(%Sequence{state: {_, 'l', _, 'c', _, _}, generator: _}=seq),
    do: (seq |> Sequence.generate) |> elem(0)
  def generate_value(seq), do: seq.state

  def generate_next(%Sequence{state: {nil, 'l', _, _, _, 0}, generator: _}),
    do: nil
  def generate_next(%Sequence{state: {s, 'l', limit, start, limit, 0}, generator: gen}),
    do: %Sequence{state: {nil, 'l', limit, start, limit, 0}, generator: gen}
  def generate_next(%Sequence{state: {s, 'l', 1, 'c', start, limit}, generator: gen}),
    do: %Sequence{state: {start, 'l', limit, 'c', start, limit}, generator: gen}
  def generate_next(%Sequence{state: {s, 'l', 1, start, limit, n}, generator: gen}) do
    %Sequence{state: {start, 'l', limit, start, limit, n - 1}, generator: gen}
  end
  def generate_next(%Sequence{state: {s, 'l', n, 'c', start, limit}, generator: gen}),
    do: %Sequence{state: {gen.(s) |> elem(1), 'l', n - 1, 'c', start, limit},
                      generator: gen}
  def generate_next(%Sequence{state: {s, 'l', l, start, limit, n}, generator: gen}) do
    %Sequence{state: {gen.(s) |> elem(1), 'l', l - 1, start, limit, n}, generator: gen}
  end
  def generate_next(%Sequence{state: {nil, 'c', start}, generator: gen}),
    do: %Sequence{state: {start, 'c', start}, generator: gen}
  def generate_next(%Sequence{state: {start=s, 'c', start}, generator: gen}),
    do: %Sequence{state: {gen.(s) |> elem(1), 'c', start}, generator: gen}
  def generate_next(%Sequence{state: {s, 'c', start}, generator: gen}),
    do: %Sequence{state: {gen.(s) |> elem(1), 'c', start}, generator: gen}
  def generate_next(%Sequence{state: {nil, 'l', _}, generator: _}), do: nil 
  def generate_next(%Sequence{state: {_, 'l', 0}, generator: _}), do: nil
  def generate_next(%Sequence{state: {s, 'l', n}, generator: gen}),
    do: {%Sequence{state: {gen.(s) |> elem(1), 'l', n - 1}, generator: gen}}
  def generate_next(%Sequence{state: nil, generator: _}), do: nil
  def generate_next(seq) do
    %Sequence{state: seq.generator.(seq.state) |> elem(1),
                          generator: seq.generator}
  end


   def advance(%Sequence{state: nil, generator: _}, _), do: nil
  def advance(seq, 0), do: seq
  def advance(seq, n), do: advance(seq |> Sequence.generate_next, n - 1) 
  
  def limit(seq, n),
    do: %Sequence{state: {seq.state, 'l', n}, generator: seq.generator}
   
  def cycle(%Sequence{state: {s, 'l', n}, generator: gen}),
    do: %Sequence{state: {s, 'l', n, 'c', s, n}, generator: gen}
  def cycle(%Sequence{state: s, generator: gen}),
    do: %Sequence{state: {s, 'c', s}, generator: gen} 
  
  def repeat(_, 0), do: nil
  def repeat(%Sequence{state: {s, 'l', limit}, generator: gen}, n),
    do: %Sequence{state: {s, 'l', limit, s, limit, n}, generator: gen}
  def repeat(seq, _), do: seq

  def concatenate(seq1, seq2), do: nil
end

# seq = %Sequence{state: 0, generator: &{&1, &1 + 1}} |> (Sequence.limit 3) |> Sequence.cycle
