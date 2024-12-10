# frozen_string_literal: true

STEPS = ('0'..'9').to_a
DIRECTIONS = { t: [-1, 0], r: [0, 1], b: [1, 0], l: [0, -1] }.freeze

def walk(current_pos, current_lv, foot_steps, peak_count = Set.new)
  foot_steps.add(current_pos)
  next_lv = (current_lv + 1) % STEPS.size

  #  look around
  @dirs.map do |dir|
    x, y = current_pos.zip(dir).map(&:sum)
    out_of_grid = [x, y].any?(&:negative?) || @map[x].nil? || @map[x][y].nil?
    next if out_of_grid || @map[x][y] != STEPS[next_lv]

    if @map[x][y] == STEPS.last
      peak_count.add([x, y])
      foot_steps.add([x, y])
    else
      walk([x, y], next_lv, foot_steps.clone, peak_count)
    end
  end
  peak_count.size
end

@dirs = DIRECTIONS.values
trail_starts = []
@map = File.read('input.txt').split("\n").map.with_index do |line, row|
  line.chars.each_with_index { trail_starts << [row, _2] if _1 == '0' }.to_a
end
trail_starts.map { walk(_1, 0, Set.new) }.sum
