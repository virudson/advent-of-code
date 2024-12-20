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

# generate map possible to walk around [x,y] => min step required to be there
# this method can be less complex
def generate_cheat_sheet(size)
  cheat_sheet = {}
  pos_list = [[0, 0]]
  step = 1
  loop do
    pos_list = pos_list.map do |current_pos|
      DIRS.each_value.map do |dir|
        next_pos = current_pos.zip(dir).map(&:sum)

        # ignoring case around self
        if next_pos.any? { _1 <= -2 || _1 >= 2 } && step >= 2
          cheat_sheet[next_pos] ||= step
        end
        next_pos
      end.compact
    end.flatten(1).uniq
    break if step == size

    step += 1
  end
  cheat_sheet.delete([0, 0])
  cheat_sheet
end

map = File.read('input.txt')
          .split("\n")
          .each_with_object({})
          .with_index do |(line, hash), row|
  line.chars.each_with_index { |char, col| hash[[row, col]] = char }
end

routes = generate_routes(map)
cheat_sheet = generate_cheat_sheet(20)
memorized = {}
result = routes.each_with_index.with_object({}) do |(current_pos, start_at), hash|
  cheat_sheet.each do |distant, step_used|
    distant_pos = current_pos.zip(distant).map(&:sum)
    next unless %w[. E].include?(map[distant_pos])

    end_at = memorized[distant_pos] || routes.find_index(distant_pos)
    memorized[distant_pos] ||= end_at
    time_saved = end_at - start_at - step_used
    next if time_saved < 100

    hash[time_saved] ||= 0
    hash[time_saved] += 1
  end
end

result.each_value.sum
