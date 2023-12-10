# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 06 - Part 2') do
    limit_time, distance = *File.read('input.txt').split("\n").map do |line|
      line.scan(/\d+/).join.to_i
    end

    counter = nil
    (limit_time / 5).upto(limit_time - 1).select do |hold_time|
      time_left = limit_time - hold_time
      move_distance = hold_time * time_left
      counter = hold_time
      break if move_distance > distance
    end
    result = limit_time - (counter * 2) + 1
    # puts "Total multiply of round: #{result}"
  end
end
