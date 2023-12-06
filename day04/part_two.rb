# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 04 - Part 2') do
    card_on_hands = Hash.new(0)

    File.foreach('input.txt') do |line|
      line.gsub(/Card\s+(\d+):\s([\d\s]+) \|\s([\d\s]+)/).each do |_m|
        current_card_no = $1
        winning_list = $2.split(' ')
        numbers = $3.split(' ')

        # add original card to hand
        card_on_hands[current_card_no.to_s] += 1

        # get draw count
        draw_count = (winning_list & numbers).size

        # add up extra card
        1.upto(draw_count) do |idx|
          new_card_no = (current_card_no.to_i + idx).to_s
          card_on_hands[new_card_no] += card_on_hands[current_card_no]
        end
      end
    end

    puts "Total scratchcards is: #{card_on_hands.values.sum}"
  end
end
