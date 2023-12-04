defmodule AOC.Day do
    defp parse_numbers(numbers) do
        numbers |> String.split(~r/\s+/) |> Enum.map(&String.to_integer/1) |> MapSet.new
    end

    def parse_line(line) do
        [id, winning, have] = Regex.run(~r/Card\s+(\d+):\s+([0-9][0-9 ]+) \|\s+([0-9][0-9 ]+)/, line, capture: :all_but_first)
        
        {id |> String.to_integer, parse_numbers(winning), parse_numbers(have)}
    end

    def play({id, winning, have}) do
        win_count = MapSet.intersection(winning, have) |> MapSet.size

        {id, {win_count, Range.new(id + 1, id + win_count, 1)}}
    end

    def total(_scores, {0, _}) do
        1
    end

    def total(scores, {_, targets}) do
        others = targets
            |> Enum.map(&total(scores, scores[&1]))
            |> Enum.sum
        
        others + 1
    end

    def solve(input) do
        scores = input
            |> String.trim
            |> String.split("\n")
            |> Enum.map(&parse_line/1)
            |> Enum.map(&play/1)
            |> Map.new

        total(scores, {map_size(scores), Map.keys(scores)}) - 1
    end
end

AOC.solve 4