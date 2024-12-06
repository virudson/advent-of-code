# frozen_string_literal: true

current_pos = nil
map = File.read('test.txt').split("\n").map.with_index do |line, idx|
  current_pos = [idx, line.chars.find_index('^')] if line =~ /\^/
  line.chars
end

direction_map = { r: [0, 1], b: [1, 0], l: [0, -1], t: [-1, 0] }
directions = %i[t r b l].reverse
direction = directions.pop
foot_steps = Set.new
foot_steps.add(current_pos)

loop do
  # sleep(0.05)
  # system("clear") || system("cls")
  x, y = current_pos.zip(direction_map[direction]).map { _1.inject(:+) }
  break if [x, y].any?(&:negative?) || map[x].nil? || map[x][y].nil?

  next_tile = map[x][y]

  if next_tile == '#'
    directions.unshift(direction)
    direction = directions.pop
  else
    # decor part
    # map[current_pos[0]][current_pos[1]] = '.'
    # map[x][y] = { t: '^', r: '>', b: 'v', l: '<' }[direction]

    foot_steps.add([x, y])
    current_pos = [x, y]
  end

  # puts map.map(&:join)
end

foot_steps.size

