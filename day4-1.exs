defmodule AOC.Day do
    defp parse_numbers(numbers) do
        numbers |> String.split(~r/\s+/) |> Enum.map(&String.to_integer/1) |> MapSet.new
    end

    def parse_line(line) do
        [id, winning, have] = Regex.run(~r/Card\s+(\d+):\s+([0-9][0-9 ]+) \|\s+([0-9][0-9 ]+)/, line, capture: :all_but_first)
        
        {id |> String.to_integer, parse_numbers(winning), parse_numbers(have)}
    end

    def play({_, winning, have}) do
        win_count = MapSet.intersection(winning, have) |> MapSet.size
        if win_count > 0 do
            Integer.pow(2, win_count - 1)
        else
            0
        end
    end

    def solve(input) do
        input
        |> String.trim
        |> String.split("\n")
        |> Enum.map(&parse_line/1)
        |> Enum.map(&play/1)
        |> Enum.sum
    end
end

AOC.solve 4