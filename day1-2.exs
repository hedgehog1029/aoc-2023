defmodule AOC.Day do
    @words %{"one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9}

    defp is_digit?(c) when c >= ?0 and c <= ?9, do: true
    defp is_digit?(_), do: false

    def find_number([match]) do
        char = match |> String.to_charlist |> hd
        if is_digit?(char) do
            String.to_integer match
        else
            @words[match]
        end
    end

    def match_all(line, matches) do
        m = Regex.run(~r/(\d|one|two|three|four|five|six|seven|eight|nine)/, line, capture: :all_but_first)
        if m == nil do
            matches
        else
            match_all(line |> String.slice(1..-1), [m | matches])
        end
    end

    def match_all(line) do
        match_all(line, [])
    end

    def find_vals(line) do
        m = match_all(line)

        # list is built backwards
        last = m |> List.first |> find_number
        first = m |> List.last |> find_number

        Integer.undigits([first, last])
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
