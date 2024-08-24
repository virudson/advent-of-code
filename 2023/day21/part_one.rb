# frozen_string_literal: true

require 'benchmark'
Benchmark.bmbm do |x|
  x.report('Day 21 - Part 1') do
    directions = { 'U' => [-1, 0], 'D' => [1, 0], 'L' => [0, -1], 'R' => [0, 1] }
    garden = File.readlines('input.txt', chomp: true).map(&:chars)
    height = garden.size
    width = garden[0].size
    start_position = garden.flat_map.with_index do |line, x|
      y = line.find_index { _1 == 'S' }
      [x, y] if y
    end.compact

    positions = [start_position]
    64.times do
      positions = positions.flat_map do |x, y|
        directions.values
                  .map { _1.zip([x, y]).map(&:sum) }
                  .select { |x, y| !(x.negative? || x >= height || y.negative? || y >= width) && %w[S .].include?(garden[x][y]) }
      end
      positions.uniq!
      # dump = File.readlines('input_demo.txt', chomp: true).map(&:chars)
      # positions.each { |x, y| dump[x][y] = 'O' }
      # puts dump.map &:join
      # puts '---------------------------'
    end
    positions.size
  end
end
