# frozen_string_literal: true

require 'rainbow/refinement'
using Rainbow

DIRECTIONS = { '^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1] }.freeze

def show_score(steps, turns, grid)
  data = steps.to_a

  data.each do |pos|
    x, y = pos
    grid[x][y] = turns.include?(pos) ? 'O'.red : 'O'.green
  end
  score = (turns.size * 1000) + steps.size
  puts "Score: #{score} / Step: #{steps.size} / Turn: #{turns.size}"
  puts grid.map(&:join), "\n\n"
  score
end

def walk(current_pos, foot_steps, turning_pos, current_dir = nil)
  # start tracking
  if current_dir
    pos1, pos2 = foot_steps.to_a.last(2)
    foot_steps.add(current_pos)
    if pos1 && pos2
      dir = pos2.zip(pos1).map { _1.inject(:-) }
      turning_pos.add(pos2) if dir != current_dir
    end
  end

  DIRECTIONS.each_value.map do |next_dir|
    if current_dir
      invert_dir = current_dir.zip([-1, -1]).map { _1.inject(:*) }
      next if invert_dir == next_dir
    end

    next_pos = current_pos.zip(next_dir).map(&:sum)
    next_tile = @map[next_pos]

    case next_tile
    when '#' then next
    when '.'
      next if foot_steps.include?(next_pos) # loop

      walk(next_pos, foot_steps.clone, turning_pos.clone, next_dir)
    when 'E'
      foot_steps.add(next_pos)
      # show_score(foot_steps, turning_pos, @file.map(&:chars))
      # return { foot_steps => turning_pos }
      return (turning_pos.size * 1000) + foot_steps.size
    end
  end
end

@file = File.read('input.txt').split("\n")
@map = @file.each_with_object({}).with_index do |(line, hash), row|
  line.chars.each_with_index { |char, col| hash[[row, col]] = char }
end
start_at = @map.key('S')
walk(start_at, Set.new, Set.new([start_at])).flatten.compact.min

# debug
result = walk(start_at, Set.new, Set.new([start_at])).flatten.compact.map(&:to_a).flatten(1)
grid = @file.map(&:chars)
result.each { |(steps, turns)| show_score(steps, turns, Marshal.load(Marshal.dump(grid))) }; 0
