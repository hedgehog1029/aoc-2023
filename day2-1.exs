defmodule AOC.Day do
  defp parse_cube(cube) do
    [count, color] = Regex.run(~r/(\d+) (\w+)/, cube, capture: :all_but_first)
    count = String.to_integer(count)
    color = String.to_atom(color)

    {color, count}
  end

  defp parse_round(round) do
    round |> String.split(", ") |> Enum.map(&parse_cube/1)
  end

  defp parse_game([game_id, inp]) do
    rounds = inp |> String.split("; ") |> Enum.map(&parse_round/1)
    maxed = rounds |> Enum.reduce(fn a, b -> Keyword.merge(a, b, fn _, c1, c2 -> max(c1, c2) end) end)

    {game_id, maxed}
  end

  defp parse_line(line) do
    [game_id, cubes] = Regex.run(~r/Game (\d+): (.+)/, line, capture: :all_but_first)

    parse_game([String.to_integer(game_id), cubes])
  end

  def is_possible({_, cubes}) do
    cubes[:red] <= 12 and cubes[:green] <= 13 and cubes[:blue] <= 14
  end

  def solve(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&is_possible/1)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum
  end
end

AOC.solve 2
