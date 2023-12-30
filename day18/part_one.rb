# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 18 - Part 1') do
    def draw(x, y, dir, distance, block = '#')
      distance.times do
        x, y = @directions[dir].zip([x, y]).map(&:sum)
        @canvas[x][y] = block
        @walls << [x, y] # draw wall
      end
    end

    @directions = { 'U' => [-1, 0], 'D' => [1, 0], 'L' => [0, -1], 'R' => [0, 1] }
    patterns = File.readlines('input.txt', chomp: true).map do
      str = _1.split(' ')
      str[1] = str[1].to_i
      str.first(2)
    end

    # finding min/max of canvas
    rows = [0, 0]
    cols = [0, 0]
    patterns.each_with_object([0, 0]) do
      direction, steps = _1.first(2)
      cols[0] = _2[0] if cols[0] > _2[0] # min width
      cols[1] = _2[0] if cols[1] < _2[0] # max width
      rows[0] = _2[1] if rows[0] > _2[1] # min height
      rows[1] = _2[1] if rows[1] < _2[1] # max height
      case direction
      when 'R' then _2[0] += steps
      when 'L' then _2[0] -= steps
      when 'U' then _2[1] -= steps
      when 'D' then _2[1] += steps
      end
    end
    height = rows[1] - rows[0] + 1
    width = cols[1] - cols[0] + 1

    # create canvas for draw
    @canvas = height.times.map { Array.new(width, '.') }
    @walls = []

    # start x pos and y pos
    x = 0 - rows[0]
    y = 0 - cols[0]
    patterns.each do |pattern|
      direction, step = pattern
      draw(x, y, direction, step)
      move_x, move_y = @directions[direction]
                         .zip([step, step])
                         .map { _1.inject(&:*) }
      x, y = [move_x, move_y].zip([x, y]).map(&:sum)
    end

    # find init empty spot
    empty_spots = []
    # finding . from left and right edge
    height.times do |x|
      empty_spots << [x, 0] if @canvas[x][0] == '.' # left side
      empty_spots << [x, width - 1] if @canvas[x][width - 1] == '.' # right side
    end
    # finding . from top and bottom edge
    width.times do |y|
      empty_spots << [0, y] if @canvas[0][y] == '.' # top side
      empty_spots << [height - 1, y] if @canvas[height - 1][y] == '.' # bottom side
    end

    # find empty space every direction
    empty_spots.uniq!
    directions = @directions.values + [[1, 1], [-1, -1], [1, -1], [-1, 1]]
    clear_spot = []

    while empty_spots.any?
      x, y = empty_spots.pop
      @canvas[x][y] = ' ' # clear it out
      clear_spot << [x, y]

      # generate list of x, y pos around current spot then select only .
      around = directions.map do
        new_x, new_y = [x, y].zip(_1).map(&:sum)
        # not outside canvas, not wall or space, not already count
        next if empty_spots.include?([new_x, new_y])
        next if new_x.negative? || new_x >= height || new_y.negative? || new_y >= width
        next if %W[# \s].include?(@canvas[new_x][new_y])

        [new_x, new_y] if @canvas[new_x][new_y] == '.'
      end.compact

      empty_spots += around
    end
    (width * height) - clear_spot.size
  end
end
