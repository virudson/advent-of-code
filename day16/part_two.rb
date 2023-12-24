# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 16 - Part 2') do
    # get target coordinate by direction
    def next_position(x, y, direction)
      case direction
      when 'U'
        x -= 1 if x.positive?
      when 'D'
        x += 1
      when 'L'
        y -= 1 if y.positive?
      when 'R'
        y += 1
      end
      [x, y]
    end

    def move_to(x, y, direction)
      current_tile = @fields.dig(x)&.dig(y)
      return if current_tile.nil? # can't go to void
      return if @travel_logs[[x, y]][direction] == 2 # passed this way

      # add travel logs
      @travel_logs[[x, y]][direction] += 1
      new_direction = @rules[current_tile][direction]

      case new_direction
      when Array
        new_direction.each do
          tx, ty = next_position(x, y, _1)
          move_to(tx, ty, _1)
        end
      when String
        tx, ty = next_position(x, y, new_direction)
        move_to(tx, ty, new_direction)
      else
        tx, ty = next_position(x, y, direction)
        move_to(tx, ty, direction)
      end
    end

    @directions = [[-1, 0, 'D'], [0, 1, 'L'], [1, 0, 'U'], [0, -1, 'R']]
    @rules = {
      '/' => { 'U' => 'R', 'D' => 'L', 'L' => 'D', 'R' => 'U' },
      '\\' => { 'U' => 'L', 'D' => 'R', 'L' => 'U', 'R' => 'D' },
      '|' => { 'L' => %w[U D], 'R' => %w[U D] },
      '-' => { 'U' => %w[L R], 'D' => %w[L R] },
      '.' => {}
    }
    @fields = File.readlines('input.txt', chomp: true).map(&:chars)
    cols = @fields.size
    rows = @fields[0].size

    result = {}

    # Loop through each element in the matrix
    rows.times do |row|
      cols.times do |col|
        # Check for left, right, up, and down directions
        @directions.each do |dir|
          new_row = row + dir[0]
          new_col = col + dir[1]
          if new_row.negative? || new_row >= rows || new_col.negative? || new_col >= cols
            @travel_logs = Hash.new { |h, k| h[k] = Hash.new(0) }
            move_to(row, col, dir[2])
            result["#{row}/#{col}:#{dir[2]}"] = @travel_logs.size
          end
        end
      end
    end
    result.values.max
  end
end
