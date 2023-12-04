defmodule AOC.Day do
    def parse_digit(result, [nondigit | tail], {x, y}) when nondigit < ?0 or nondigit > ?9 do
        {result |> Enum.reverse |> List.to_integer, [nondigit | tail], {x + length(result), y}}
    end

    def parse_digit(result, [digit | tail], {x, y}) do
        parse_digit([digit | result], tail, {x, y})
    end

    def parse(result, [], _) do
        result
    end

    def parse(result, [?. | tail], {x, y}) do
        parse(result, tail, {x + 1, y})
    end

    def parse(result, [?\n | tail], {_x, y}) do
        parse(result, tail, {0, y + 1})
    end

    def parse(result, [digit | tail], {x, y}) when digit >= ?0 and digit <= ?9 do
        {n, tail, coords} = parse_digit([], [digit | tail], {x, y})

        parse(Map.put(result, {x, y}, {:number, n, length(Integer.digits(n))}), tail, coords)
    end

    def parse(result, [symbol | tail], {x, y}) do
        parse(Map.put(result, {x, y}, {:symbol, symbol}), tail, {x + 1, y})
    end

    def has_gear({{x, y}, {:number, _, len}}, grid) do 
        surrounding =
            for ty <- Range.new(y - 1, y + 1),
                tx <- Range.new(x - 1, x + len) do
                {{tx, ty}, grid[{tx, ty}]}
            end
        
        gear = Enum.find(surrounding, fn
            {_, {:symbol, ?*}} -> true
            _ -> false
        end)

        {{x, y}, gear}
    end

    def solve(input) do
        grid = parse(%{}, String.to_charlist(input), {0, 0})
        grid
        |> Enum.filter(fn
            {_, {:number, _, _}} -> true
            _ -> false
        end)
        |> Enum.map(&has_gear(&1, grid))
        |> Enum.filter(fn
            {_, nil} -> false
            _ -> true
        end)
        |> Enum.group_by(fn {_, {key, _}} -> key end)
        |> Enum.filter(fn {_, group} -> length(group) == 2 end)
        |> Enum.map(fn {_, [{a, _}, {b, _}]} ->
            {:number, left, _} = grid[a]
            {:number, right, _} = grid[b]
            left * right
        end)
        |> Enum.sum
    end
end

AOC.solve 3