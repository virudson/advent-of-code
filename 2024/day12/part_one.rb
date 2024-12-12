# frozen_string_literal: true

def explore_region(current_pos, area = Set.new, borders = Set.new)
  return unless @foot_steps.add?(current_pos)

  area.add(current_pos)
  @dirs.each do |dir|
    new_pos = current_pos.zip(dir).map(&:sum)

    if @map[new_pos].nil? || @map[new_pos] != @map[current_pos]
      borders.add([current_pos, new_pos])
    else
      explore_region(new_pos, area, borders)
    end
  end

  area.size * borders.size
end

DIRECTIONS = { t: [-1, 0], r: [0, 1], b: [1, 0], l: [0, -1] }.freeze
@dirs = DIRECTIONS.values

@foot_steps = Set.new
@map = File.read('input.txt').split("\n").each_with_object({}).with_index do |(line, hash), row|
  line.chars.each_with_index { |area, col| hash[[row, col]] = area }
end

regions = @map.each_with_object({}) do |(pos, area), hash|
  next if @foot_steps.include?(pos)

  hash[area] ||= []
  hash[area] << explore_region(pos)
end
regions.values.flatten.sum
