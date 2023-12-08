defmodule AOC.Day do
    defp parse_instructions(line) do
        line
        |> String.to_charlist
        |> Enum.map(fn
            ?L -> :left
            ?R -> :right
        end)
    end

    defp parse_element(line) do
        [this, left, right] = Regex.run(~r/([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)/, line, capture: :all_but_first)
        {this, {left, right}}
    end

    defp parse_network(lines) do
        lines
        |> String.split("\n")
        |> Enum.map(&parse_element/1)
        |> Map.new
    end

    def run(_, "ZZZ", _, steps) do
        steps
    end

    def run({network, instructions}, node, [], steps) do
        run({network, instructions}, node, instructions, steps)
    end

    def run({network, instructions}, node, [next | tail], steps) do
        {l, r} = network[node]
        
        next_node = 
            case next do
                :left -> l
                :right -> r
            end

        run({network, instructions}, next_node, tail, steps + 1)
    end

    def run({network, instructions}, node) do
        run({network, instructions}, node, [], 0)
    end

    def solve(input) do
        [instructions, network] = input |> String.trim |> String.split("\n\n")

        run({parse_network(network), parse_instructions(instructions)}, "AAA")
    end
end

AOC.solve 8