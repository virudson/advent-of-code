# frozen_string_literal: true

DIRECTIONS = { t: [-1, 0], r: [0, 1], b: [1, 0], l: [0, -1] }.freeze
@dirs = DIRECTIONS.values

def count_sides(borders)
  side_counter = 0
  list = borders.sort { |a, b| a[1][0] != b[1][0] ? a[1][0] <=> b[1][0] : a[1][1] <=> b[1][1] }
  # puts "Borders: #{list}"

  list.each do |(pos, border)|
    next unless borders.include?([pos, border])

    borders.delete([pos, border])
    side_counter += 1

    px, py = pos
    bx, by = border
    dir = [bx - px, by - py]
    facing = DIRECTIONS.key(dir)
    next_dir = %i[t b].include?(facing) ? DIRECTIONS[:r] : DIRECTIONS[:b]

    # puts "Border: #{border} at #{facing} of POS: #{pos}"
    # puts "Looking #{DIRECTIONS.key(next_dir)}"

    loop do
      next_pos = pos.zip(next_dir).map(&:sum)
      next_border = border.zip(next_dir).map(&:sum)
      # puts "Look next border: #{next_border} of POS: #{next_pos}"

      # go on until end of side
      break unless borders.include?([next_pos, next_border])

      # puts 'Found!!'
      borders.delete([next_pos, next_border])
      pos = next_pos
      border = next_border
    end
    # puts 'Not Found!!'

    break if borders.empty?
  end
  side_counter
end

def explore_region(current_pos, area = Set.new, borders = Set.new, main_loop = true)
  return unless @foot_steps.add?(current_pos)

  area.add(current_pos)
  @dirs.each do |dir|
    new_pos = current_pos.zip(dir).map(&:sum)

    if @map[new_pos].nil? || @map[new_pos] != @map[current_pos]
      borders.add([current_pos, new_pos])
    else
      explore_region(new_pos, area, borders, false)
    end
  end
  return unless main_loop
  return area.size * 4 if area.size <= 2

  is_same_line = area.map { |(x, _)| x }.uniq.size == 1
  is_same_line || area.map { |(_, y)| y }.uniq.size == 1
  return area.size * 4 if is_same_line

  # finding sides
  side_counter = count_sides(borders.clone)
  area.size * side_counter
end

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
