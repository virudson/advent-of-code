# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 07 - Part 2') do
    @card_power = %w[J 2 3 4 5 6 7 8 9 T Q K A].zip(1..13).to_h
    @type_power = %w[11111 1112 122 113 23 14 5].zip(1..7).to_h

    def compare_type(hand1, hand2)
      @type_power[hand_type(hand1)] <=> @type_power[hand_type(hand2)]
    end

    def compare_card(card1, card2)
      @card_power[card1] <=> @card_power[card2]
    end

    # returns 11111 1112 122 113 23 14 5 depending on cards in hand
    def hand_type(hand)
      a_cards = hand.chars.tally

      if hand.include?('J') && hand != 'JJJJJ'
        joker_count = a_cards.delete('J')
        most_card = a_cards.key(a_cards.values.max)
        a_cards[most_card] += joker_count
      end
      a_cards.values.sort.join
    end

    def compare_hand(hand1, hand2)
      result = compare_type(hand1, hand2)
      return result if result != 0

      5.times do |index|
        result = compare_card(hand1[index], hand2[index])
        return result if result != 0
      end
      0
    end

    hands = File.readlines('input.txt').map do |line|
      cards, bid = line.scan(/\w+/)
      [cards, bid.to_i]
    end

    hands.sort! { |h1, h2| compare_hand(h1[0], h2[0]) };
    hands.each.with_index(1).inject(0) do |sum, (hand, index)|
      sum + (hand[1] * index)
    end
  end
end
