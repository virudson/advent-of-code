# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 04 - Part 1') do
    sum = 0

    File.foreach('input.txt') do |line|
      line.gsub(/:\s([\d\s]+)\s\|\s([\d\s]+)/).each do |_m|
        winning_list = $1.split(' ')
        numbers = $2.split(' ')

        # get intersection array
        winning_count = (winning_list & numbers).size

        # calculate points
        sum += 2 ** (winning_count - 1) if winning_count != 0
      end
    end

    puts "Total winning points is: #{sum}"
  end
end
