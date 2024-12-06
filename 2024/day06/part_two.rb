# frozen_string_literal: true

def walk(current_pos, dir, foot_steps, main_loop: false)
  loop do
    x, y = current_pos.zip(@directions.values[dir]).map(&:sum)
    out_of_grid = [x, y].any?(&:negative?) || @map[x].nil? || @map[x][y].nil?
    return main_loop if out_of_grid

    next_dir = (dir + 1) % 4
    (dir = next_dir) && next if @map[x][y] == '#'

    if main_loop
      never_go = foot_steps.none? { |_facing, pos| pos == [x, y] }

      # go to new way if never go
      if never_go
        @map[x][y] = '#'
        @loop_counter += 1 if walk(current_pos, dir, foot_steps.clone)
        @map[x][y] = '.'
      end
    end

    current_pos = [x, y]
    is_added = foot_steps.add?([@facing[dir], current_pos])
    return true if is_added.nil?
  end
end

@directions = { t: [-1, 0], r: [0, 1], b: [1, 0], l: [0, -1] }
@facing = @directions.keys
start_at = nil
@map = File.read('input.txt').split("\n").map.with_index do
  start_at = [_2, _1.chars.find_index('^')] if _1 =~ /\^/
  _1.chars
end

foot_steps = Set.new([@facing[0], start_at])
@loop_counter = 0
walk(start_at, 0, foot_steps, main_loop: true)
