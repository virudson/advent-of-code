# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 18 - Part 1') do
    # 0 => R, 1 => D, 2 => L, 3 => U
    @directions = { '3' => [-1, 0], '1' => [1, 0], '2' => [0, -1], '0' => [0, 1] }
    patterns = File.readlines('input.txt', chomp: true).map do
      str = _1.split(' ').last
      [str[-2], str[2..-3].to_i(16)]
    end

    # https://en.wikipedia.org/wiki/Shoelace_formula
    distances = 0
    vertices = [[0, 0]]
    x, y = vertices.first
    patterns.each do |pattern|
      direction, step = pattern
      x, y = @directions[direction]
               .map { |dir| dir * step }
               .zip([x, y])
               .map(&:sum)
      distances += step
      vertices << [y, x]
    end

    area = (vertices.size - 1).times.sum do |index|
      x1, y1 = vertices[index]
      x2, y2 = vertices[index + 1]
      (x1 * y2) - (x2 * y1)
    end
    (area / 2) + (distances / 2) + 1
  end
end
