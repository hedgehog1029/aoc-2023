defmodule AOC do
  def input(n) do
    File.read!("inputs/day#{n}.txt")
  end

  def solve(n) do
    file = input(n)
    {time, result} = :timer.tc(AOC.Day, :solve, [file])
    IO.inspect result
    IO.puts "* Completed in #{time}us (#{time / 1000}ms)"
  end
end