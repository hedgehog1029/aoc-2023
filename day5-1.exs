defmodule AOC.Day do
    defp parse_range(input) do
        [dst, src, len] = input |> String.split(" ") |> Enum.map(&String.to_integer/1)

        {Range.new(src, src + len - 1), Range.new(dst, dst + len - 1)}
    end

    defp parse_group([_, src, dst, maps]) do
        ranges = maps |> String.trim |> String.split("\n") |> Enum.map(&parse_range/1)

        {src, dst, ranges}
    end

    defp parse_groups(input) do
        Regex.scan(~r/(\w+)-to-(\w+) map:\s+([0-9 \n]+)\n\n?/, input)
        |> Enum.map(&parse_group/1)
    end

    defp parse_seeds(input) do
        [seed_list, tail] = Regex.run(~r/seeds: ([0-9 ]+)\n\n(.+)/s, input, capture: :all_but_first)
        seeds = seed_list |> String.split(" ") |> Enum.map(&String.to_integer/1)
        
        {seeds, tail}
    end

    def run([], result) do
        result
    end

    def run([{_src, _dst, ranges} | tail], src_id) do
        dst_id = case Enum.find(ranges, fn {src, _} -> src_id in src end) do
            {src, dst} -> src_id - src.first + dst.first
            nil -> src_id
        end

        run(tail, dst_id)
    end

    def solve(input) do
        {seeds, tail} = parse_seeds(String.trim(input))
        groups = parse_groups(tail)

        seeds
        |> Enum.map(&run(groups, &1))
        |> Enum.min
    end
end

AOC.solve 5