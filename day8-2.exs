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

    defp lcm([result]), do: result
    defp lcm([a, b | tail]) do
        step = div((a * b), Integer.gcd(a, b))
        lcm([step | tail])
    end

    defp move(network, node, :left) do
        network[node] |> elem(0)
    end

    defp move(network, node, :right) do
        network[node] |> elem(1)
    end

    def run(_, node, _, steps) when binary_part(node, 2, 1) == "Z" do
        steps
    end

    def run({network, instructions}, node, [], steps) do
        run({network, instructions}, node, instructions, steps)
    end

    def run({network, instructions}, node, [next | tail], steps) do
        next_node = move(network, node, next)

        run({network, instructions}, next_node, tail, steps + 1)
    end

    def run({network, instructions}, node) do
        run({network, instructions}, node, [], 0)
    end

    def solve(input) do
        [instructions, network] = input |> String.trim |> String.split("\n\n")
        network = parse_network(network)

        Map.keys(network)
        |> Enum.filter(&String.ends_with?(&1, "A"))
        |> Enum.map(&run({network, parse_instructions(instructions)}, &1))
        |> lcm
    end
end

AOC.solve 8