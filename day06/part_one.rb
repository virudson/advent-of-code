# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 06 - Part 1') do
    times, win_condition = *File.read('input.txt').split("\n").map do |line|
      line.scan(/\d+/).map(&:to_i)
    end
    rounds = times.zip(win_condition)

    result = rounds.map do |round|
      limit_time = round[0]
      distance = round[1]
      counter = nil
      1.upto(limit_time - 1).select do |hold_time|
        time_left = limit_time - hold_time
        move_distance = hold_time * time_left
        counter = hold_time
        break if move_distance > distance
      end
      limit_time - (counter * 2) + 1
    end
    # puts "Total multiply of round: #{result.inject(&:*)}"
  end
end
