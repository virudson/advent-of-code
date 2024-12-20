# frozen_string_literal: true

DIRS = { '^' => [-1, 0], '>' => [0, 1], 'v' => [1, 0], '<' => [0, -1] }.freeze

# generate normal routes
def generate_routes(map)
  steps = Set.new
  current_pos = map.key('S')
  loop do
    steps << current_pos

    DIRS.each_value do |dir|
      next_pos = current_pos.zip(dir).map(&:sum)

      next unless %w[. E].include?(map[next_pos])

      if steps.add?(next_pos)
        current_pos = next_pos
        break
      end
    end
    break if current_pos == map.key('E')
  end
  steps.to_a
end

map = File.read('input.txt')
          .split("\n")
          .each_with_object({})
          .with_index do |(line, hash), row|
  line.chars.each_with_index { |char, col| hash[[row, col]] = char }
end

routes = generate_routes(map)
result = routes.map.with_index do |pos, start_at|
  DIRS.each_value.map do |dir|
    cheat_dir = dir.zip([2, 2]).map { _1.inject(:*) }
    cheat_pos = pos.zip(cheat_dir).map(&:sum)

    if routes.include?(cheat_pos)
      end_at = routes.find_index(cheat_pos)
      (end_at - start_at - 2).positive? ? (end_at - start_at - 2) : nil
    end
  end
end.flatten.compact; 0
result.select { _1 >= 100 }.size
