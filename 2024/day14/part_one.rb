# frozen_string_literal: true

room_height = 103
room_width = 101
seconds = 100
# map = room_height.times.map { Array.new(room_width, '.') }

File
  .read('input.txt')
  .gsub(/-?\d+/)
  .map(&:to_i)
  .each_slice(4)
  .each_with_object(Array.new(4, 0)) do |(py, px, vy, vx), ary|
  x, y = [px, py].zip([vx * seconds, vy * seconds]).map(&:sum)
  x %= room_height
  y %= room_width

  h_wall = room_height / 2
  v_wall = room_width / 2

  next if x == h_wall || y == v_wall

  # tile = map[x][y]
  # map[x][y] = tile.is_a?(String) ? 1 : tile + 1

  # assign to zone
  if x < h_wall && y < v_wall
    ary[0] += 1
  elsif x < h_wall && y > v_wall
    ary[1] += 1
  elsif x > h_wall && y < v_wall
    ary[2] += 1
  else
    ary[3] += 1
  end
end.inject(:*)

# puts map.map(&:join), ' '
