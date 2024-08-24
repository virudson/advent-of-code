# frozen_string_literal: true

require 'benchmark'
Benchmark.bmbm do |x|
  x.report('Day 23 - Part 1') do
    # move until separate ways
    def move(x, y, count = 0)
      positions = []
      loop do
        count += 1
        @trails[x][y] = 'O'
        return count if [x, y] == [@height - 1, @end_position]

        positions = @directions.values
                               .map { _1.zip([x, y]).map(&:sum) }
                               .reject { |x, y| x.negative? || x >= @height || y.negative? || y >= @width }
                               .reject { |x, y| %w[# O].include?(@trails[x][y]) }
        break if positions.size > 1

        x, y = positions[0]
      end
      [positions, count]
    end

    @directions = { 'U' => [-1, 0], 'D' => [1, 0], 'L' => [0, -1], 'R' => [0, 1] }
    @trails = File.readlines('input_demo.txt', chomp: true).map(&:chars)
    @height = @trails.size
    @width = @trails[0].size
    @start_position = @trails[0].find_index { _1 == '.' }
    @end_position = @trails[@width - 1].find_index { _1 == '.' }

    positions, count = move(0, @start_position)
  end
end
