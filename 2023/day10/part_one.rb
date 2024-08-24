# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 10 - Part 1') do
    # get target coordinate by direction
    def coordinate_by(x, y, direction)
      case direction
      when 'T'
        x -= 1 if x.positive?
      when 'B'
        x += 1
      when 'L'
        y -= 1 if y.positive?
      when 'R'
        y += 1
      end
      [x, y]
    end

    def direction_by(x, y)
      current = @maze[x][y]
      return if current !~ /[#{@slots.keys.sort.join}]/

      # get movable coordinate by current coordinate
      @slots[current].chars.map do |direction|
        tx, ty = coordinate_by(x, y, direction)
        target = @maze[tx] ? @maze[tx][ty] : nil

        [tx, ty] if target =~ /[#{@connects[direction]}]/
      end.compact
    end

    def replace_maze(x, y)
      current = @maze[x][y]
      @maze[x][y] = @replaces[current]
    end

    @slots = { 'S' => 'TBLR', '|' => 'TB', '-' => 'LR', 'L' => 'TR', 'J' => 'TL', '7' => 'BL', 'F' => 'BR' }
    @connects = { 'T' => '|7F', 'B' => '|JL', 'L' => '-LF', 'R' => '-7J' }
    @replaces = { 'S' => 'S', '|' => '║', '-' => '═', 'L' => '╚', 'J' => '╝', '7' => '╗', 'F' => '╔' }

    @maze = File.readlines('input.txt', chomp: true)
    start_position = @maze.flat_map.with_index do |line, index|
      line.scan(/S/).map do |_m|
        [index, Regexp.last_match.pre_match.size]
      end
    end.first
    positions = [start_position]
    step = 1
    loop do
      positions.uniq!
      # found last dead end
      break if positions.size == 1 && positions != [start_position]

      positions = positions.flat_map do |position|
        # return next movable position
        next_position = direction_by(*position)

        # replace current position with step counter
        replace_maze(*position)
        next_position
      end.compact

      step += 1
    end
    puts "Total steps that take from start to farthest position is: #{step - 1}"
  end
end
