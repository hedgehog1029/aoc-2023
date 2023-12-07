defmodule AOC.Day do
    defp parse_line(line) do
        [hand, bid] = Regex.run(~r/([2-9JQKAT]+) (\d+)/, line, capture: :all_but_first)

        {String.to_charlist(hand), String.to_integer(bid)}
    end

    defp value_of(card) do
        case card do
            ?A -> 12
            ?K -> 11
            ?Q -> 10
            ?J -> 9
            ?T -> 8
            ?9 -> 7
            ?8 -> 6
            ?7 -> 5
            ?6 -> 4
            ?5 -> 3
            ?4 -> 2
            ?3 -> 1
            ?2 -> 0
        end
    end

    def hand_type(hand) do
        freqs = Enum.frequencies(hand)
        case Map.values(freqs) |> Enum.sort do
            [5] -> {:five_of_a_kind, 78}
            [1, 4] -> {:four_of_a_kind, 65}
            [2, 3] -> {:full_house, 52}
            [1, 1, 3] -> {:three_of_a_kind, 39}
            [1, 2, 2] -> {:two_pair, 26}
            [1, 1, 1, 2] -> {:one_pair, 13}
            _ -> {:high_card, 0}
        end
    end

    def hand_value({hand, _}) do
        {_, hand_score} = hand_type(hand)
        card_values = hand |> Enum.map(&value_of/1)
        
        [hand_score | card_values] |> List.to_tuple
    end

    defp calc_score({{_, bid}, rank}) do
        bid * rank
    end

    def solve(input) do
        input
        |> String.trim
        |> String.split("\n")
        |> Enum.map(&parse_line/1)
        |> Enum.sort_by(&hand_value/1)
        |> Enum.with_index(1)
        |> Enum.map(&calc_score/1)
        |> Enum.sum
    end
end

AOC.solve 7