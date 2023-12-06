defmodule AOC.Day do
    def parse_time(input) do
        [times] = Regex.run(~r/Time:\s+([0-9 ]+)/, input, capture: :all_but_first)
        times |> String.split(~r/\s+/) |> Enum.map(&String.to_integer/1)
    end

    def parse_distance(input) do
        [distances] = Regex.run(~r/Distance:\s+([0-9 ]+)/, input, capture: :all_but_first)
        distances |> String.split(~r/\s+/) |> Enum.map(&String.to_integer/1)
    end

    defp distance(time_held, total_time) do
        (total_time - time_held) * time_held
    end

    def count_ways({time, min_distance}) do
        1..time
        |> Enum.map(&distance(&1, time))
        |> Enum.filter(fn d -> d > min_distance end)
        |> Enum.count
    end

    def solve(input) do
        [time, dist] = input |> String.trim |> String.split("\n")
        Enum.zip(parse_time(time), parse_distance(dist))
        |> Enum.map(&count_ways/1)
        |> Enum.product
    end
end

AOC.solve 6