# frozen_string_literal: true

DIR = { t: [-1, 0], r: [0, 1], b: [1, 0], l: [0, -1] }.freeze

grid_size = 71
corrupted_size = 1024
# grid_size = 7
# corrupted_size = 12
map = grid_size.times.map { |_row| Array.new(grid_size, '.') }
blocked = File.read('input.txt').gsub(/\d+/).map(&:to_i).each_slice(2).to_a
blocked.first(corrupted_size).each { |(col, row)| map[row][col] = '#' }
@grid = map.each_with_object({}).with_index do |(line, hash), row|
  line.each_with_index { |tile, col| hash[[row, col]] = tile }
end

def move(current_pos, steps)
  DIR.values.map do |dir|
    next_pos = current_pos.zip(dir).map(&:sum)
    next_pos if @grid[next_pos] == '.' && !steps.include?(next_pos)
  end.compact
end

start_at = [0, 0]
destination = [grid_size - 1, grid_size - 1]
steps = Set.new([start_at])
next_moves = [start_at]

counter = 0
loop do
  next_moves = next_moves.map { |pos| move(pos, steps.clone) }.flatten(1).uniq
  counter += 1
  break if next_moves.include?(destination)

  next_moves.each { steps.add(_1) }
end

puts counter
