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
            ?T -> 9
            ?9 -> 8
            ?8 -> 7
            ?7 -> 6
            ?6 -> 5
            ?5 -> 4
            ?4 -> 3
            ?3 -> 2
            ?2 -> 1
            ?J -> 0
        end
    end

    def expand_jokers(hand) do
        ~c"23456789TQKA" |> Enum.map(fn replacement ->
            hand |> Enum.map(fn
                ?J -> replacement
                c -> c
            end)
        end)
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

    def best_hand_type(hand) do
        expand_jokers(hand)
        |> Enum.map(&hand_type/1)
        |> Enum.max_by(fn {_, score} -> score end)
    end

    def hand_value({hand, _}) do
        {_, hand_score} = best_hand_type(hand)
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