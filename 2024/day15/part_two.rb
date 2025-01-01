# frozen_string_literal: true

DIRECTIONS = { '^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1] }.freeze
FACING = { '^' => 'UP', '>' => 'RIGHT', 'v' => 'DOWN', '<' => 'LEFT' }.freeze

def show_map(grid, map)
  temp = grid.map(&:chars)
  map.each_key { |(x, y)| temp[x][y] = map.values_at([x, y]) }
  puts temp.map(&:join), "\n"
end

def swap_tile(dir1, dir2, map)
  dir1_tile = map[dir1]
  dir2_tile = map[dir2]
  map[dir1] = dir2_tile
  map[dir2] = dir1_tile
end

def get_box(box_pos, map)
  if map[box_pos] == ']'
    [box_pos.zip(DIRECTIONS['<']).map(&:sum), box_pos]
  elsif map[box_pos] == '['
    [box_pos, box_pos.zip(DIRECTIONS['>']).map(&:sum)]
  else
    raise 'INVALID BOX'
  end
end

def move(pos, dir, map, swap: false)
  current_tile = map[pos]
  next_pos = pos.zip(dir).map(&:sum)
  # puts "current_tile is #{current_tile}"
  # puts "move to #{DIRECTIONS.key(dir)}"
  case current_tile
  when '.' then true
  when '@'
    return false unless move(next_pos, dir, map, swap:)

    swap_tile(pos, next_pos, map) if swap
    true
  when '[', ']'
    box_pos = %w[< >].include?(DIRECTIONS.key(dir)) ? [pos] : get_box(pos, map)
    return false unless box_pos.all? { move(_1.zip(dir).map(&:sum), dir, map, swap:) }

    box_pos.each { swap_tile(_1, _1.zip(dir).map(&:sum), map) } if swap
    true
  else
    false
  end
end

grid, steps = File.read('input.txt').split("\n\n")
steps = steps.split("\n").join.chars
grid = grid.split("\n").map do |line|
  line.chars.map do |char|
    case char
    when '@' then '@.'
    when 'O' then '[]'
    when '.', '#' then char * 2
    end
  end.join
end
map = grid.each_with_object({}).with_index do |(line, hash), row|
  line.chars.each_with_index { |char, col| hash[[row, col]] = char }
end
pos = map.key('@')

show_map(grid, map)
steps.size.times do
  step = steps[_1]
  dir = DIRECTIONS[step]
  next unless move(pos, dir, map)

  move(pos, dir, map, swap: true)
  pos = pos.zip(dir).map(&:sum)
  # show_map(grid, map)
end

map.sum { |((row, col), tile)| tile == '[' ? (100 * row) + col : 0 }
