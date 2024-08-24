# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 14 - Part 1') do
    # Gravity falling to left side
    def apply_gravity(input)
      input.map do |line|
        temp_line = line.join.split(/#/)
        temp_line.map! do |section|
          counter = section.chars.tally # count chars
          ('O' * counter['O'].to_i) + ('.' * counter['.'].to_i)
        end
        temp_line.join('#').ljust(line.size, '#').chars
      end
    end

    input = File.readlines('input.txt', chomp: true).map(&:chars)

    # input.transpose will rotate input
    # from: L <-> R as W <-> E
    # to:   L <-> R as N <-> S
    tilt_north = apply_gravity(input.transpose)

    # rotate back for calculation
    rock_counter = tilt_north.transpose.map { |line| line.tally['O'].to_i }
    rock_counter.each_with_index.sum do |sum, index|
      sum * (input.size - index)
    end
  end
end
