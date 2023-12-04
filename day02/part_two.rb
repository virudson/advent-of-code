# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 02 - Part 2') do
    sum = 0
    File.foreach('input.txt').each do |line|
      cube_count = Hash.new(0)
      # capture any digits following color red, green, blue
      line.gsub(/(\d+) (red|green|blue)/) do |_m|
        # $1: number of cubes
        # $2: color
        cube_count[$2] = $1.to_i if cube_count[$2] < $1.to_i
      end

      # The power of a set of cubes
      sum += cube_count.values.inject(&:*)
    end

    puts "Sum of the power of game set is: #{sum}"
  end
end
