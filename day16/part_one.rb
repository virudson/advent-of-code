# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 16 - Part 1') do
    # get target coordinate by direction
    def next_position(x, y, direction)
      @directions[direction].zip([x, y]).map(&:sum)
    end

    def move_to(x, y, direction)
      return if x < 0 || y < 0 || x >= @rows || y >= @cols # outside fields
      return if @travel_logs[[x, y]][direction].positive? # passed this way

      # add travel logs
      @travel_logs[[x, y]][direction] += 1
      current_tile = @fields[x][y]
      new_direction = @rules[current_tile][direction]

      if new_direction
        new_direction.each do
          tx, ty = next_position(x, y, _1)
          move_to(tx, ty, _1)
        end
      else
        tx, ty = next_position(x, y, direction)
        move_to(tx, ty, direction)
      end
    end

    @directions = { 'U' => [-1, 0], 'D' => [1, 0], 'L' => [0, -1], 'R' => [0, +1] }
    @rules = {
      '/' => { 'U' => %w[R], 'D' => %w[L], 'L' => %w[D], 'R' => %w[U] },
      '\\' => { 'U' => %w[L], 'D' => %w[R], 'L' => %w[U], 'R' => %w[D] },
      '|' => { 'L' => %w[U D], 'R' => %w[U D] },
      '-' => { 'U' => %w[L R], 'D' => %w[L R] },
      '.' => {}
    }
    @fields = File.readlines('input.txt', chomp: true).map(&:chars)
    @rows = @fields.size
    @cols = @fields[0].size

    @travel_logs = Hash.new { |h, k| h[k] = Hash.new(0) }
    move_to(0, 0, 'R')
    @travel_logs.size
  end
end
