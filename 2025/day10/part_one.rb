instructions = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
                   .split("\n")
                   .map do |line|
  line
    .split(/\s/)
    .yield_self do
    [
      it.first[1..-2].chars.map.with_index { |slot, index| index if slot == "#" }.compact,
      it[1..-2].map { |btn| btn[1..-2].split(',').map(&:to_i) }
    ]
  end
end

def press_by_steps(steps)
  steps
    .flatten
    .group_by(&:itself)
    .select { |_, v| v.size % 2 == 1 }
    .keys
    .sort
end

def find_least_press(target, buttons)
  return 1 if buttons.include?(target)

  2.upto(buttons.size) do |round|
    buttons.combination(round) do |press_steps|
      return round if press_by_steps(press_steps) == target
    end
  end
end

result = instructions.sum do |(target, buttons)|
  find_least_press(target, buttons)
end

puts result
