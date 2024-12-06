# frozen_string_literal: true

current_pos = nil
map = File.read('input.txt').split("\n").map.with_index do |line, idx|
  current_pos = [idx, line.chars.find_index('^')] if line =~ /\^/
  line.chars
end

directions = { t: [-1, 0], r: [0, 1], b: [1, 0], l: [0, -1] }.values
dir = 0
foot_steps = Set.new
foot_steps.add(current_pos)

loop do
  x, y = current_pos.zip(directions[dir]).map(&:sum)
  out_of_grid = [x, y].any?(&:negative?) || map[x].nil? || map[x][y].nil?
  break if out_of_grid

  if map[x][y] == '#'
    dir = (dir + 1) % 4
  else
    foot_steps.add([x, y])
    current_pos = [x, y]
  end
end

foot_steps.size