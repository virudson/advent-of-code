# frozen_string_literal: true

DIRECTIONS = { '^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1] }.freeze

def show_map(grid, map)
  temp = grid.split("\n").map(&:chars)
  map.each_key { |(x, y)| temp[x][y] = map.values_at([x, y]) }
  puts temp.map(&:join), "\n"
end

def move(current_pos, dir, map)
  next_pos = current_pos.zip(dir).map(&:sum)
  current_tile = map[current_pos]
  next_tile = map[next_pos]

  result = case next_tile
           when 'O' then move(next_pos, dir, map)
           when '.' then true
           when '#' then false
           end
  return false unless result

  map[next_pos] = current_tile
  map[current_pos] = '.'
  true
end

grid, steps = File.read('input.txt').split("\n\n")
steps = steps.split("\n").join.chars

map = grid.split("\n").each_with_object({}).with_index do |(line, hash), row|
  line.chars.each_with_index { |char, col| hash[[row, col]] = char }
end

pos = map.key('@')
steps.each do |step|
  dir = DIRECTIONS[step]
  pos = move(pos, dir, map) ? pos.zip(dir).map(&:sum) : pos
end
show_map(grid, map)

map.sum { |((row, col), tile)| tile == 'O' ? (100 * row) + col : 0 }
