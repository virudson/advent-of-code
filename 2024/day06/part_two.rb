# frozen_string_literal: true

start_at = nil
@map = File.readlines('input.txt').map.with_index do |line, idx|
  start_at = [idx, line.chars.find_index('^')] if line =~ /\^/
  line.delete("\n").chars
end

@current_pos = start_at
@direction_map = { r: [0, 1], b: [1, 0], l: [0, -1], t: [-1, 0] }
@directions = %i[t r b l].reverse
@direction = @directions.pop
@loop_counter = 0

def is_loop?
  map = File.read('input.txt').split("\n").map(&:chars)
  current_pos = @current_pos
  ori_pos = @current_pos.dup
  ori_dir = @direction.dup
  direction = @direction.dup
  directions = @directions.dup
  turn_list = [{ direction => current_pos }]

  # manual turn
  directions.unshift(direction)
  direction = directions.pop

  # run until exit
  loop do
    x, y = current_pos.zip(@direction_map[direction]).map { _1.inject(:+) }
    return false if [x, y].any?(&:negative?) || map[x].nil? || map[x][y].nil?

    if ori_pos == [x, y] && ori_dir == direction
      return true
    end

    next_tile = map[x][y]

    if next_tile == '#'
      turn_list << { direction => current_pos }
      directions.unshift(direction)
      direction = directions.pop
    else
      current_pos = [x, y]
      map[x][y] = { t: '|', r: '-', b: '|', l: '-' }[direction].green
    end
  end
  true
end

loop do
  x, y = @current_pos.zip(@direction_map[@direction]).map { _1.inject(:+) }
  break if [x, y].any?(&:negative?) || @map[x].nil? || @map[x][y].nil?

  if @map[x][y] == '#'
    @directions.unshift(@direction)
    @direction = @directions.pop
  else
    @current_pos = [x, y]

    # if there are any obstacle at right side then go simulate a loop
    next_dir = @directions.last
    line = case next_dir
           when :t then @map.size.times.map { |i| @map[i][y] }.join[0..x]
           when :b then @map.size.times.map { |i| @map[i][y] }.join[x..]
           when :r then @map[x].join[y..]
           when :l then @map[x].join[0..y]
           end
    @loop_counter += 1 if line =~ /#/ && is_loop?
  end
end


