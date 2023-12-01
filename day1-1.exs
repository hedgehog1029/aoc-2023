defmodule AOC.Day do
    defp is_digit?(c) when c >= ?0 and c <= ?9, do: true
    defp is_digit?(_), do: false

    def find_vals(line) do
        chars = line |> String.to_charlist
        first = Enum.find(chars, &is_digit?/1)
        last = chars |> Enum.reverse |> Enum.find(&is_digit?/1)
        
        if first == nil or last == nil do
            raise "invalid line: '#{line}'"
        end

        [first, last] |> to_string |> String.to_integer
    end

    def solve(input) do
        input
        |> String.trim
        |> String.split("\n")
        |> Enum.map(&find_vals/1)
        |> Enum.sum
    end
end

AOC.solve 1
