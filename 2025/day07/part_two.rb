@map = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
           .split("\n")
           .each_with_object({}).with_index do |(line, hash), x|
  0.upto(line.strip.size - 1) do |y|
    hash[[x, y]] = line[y]
  end
end

def lower_pos(current_pos)
  current_pos.zip([1, 0]).map(&:sum)
end

# return 2 pos around current_pos
def split_beam(current_pos)
  [
    current_pos.zip([0, -1]).map(&:sum),
    current_pos.zip([0, 1]).map(&:sum)
  ]
end

ongoing_beam_pos = { @map.key('S') => 1 }
counter = 0
loop do
  counter += 1
  ongoing_pos = {}
  ongoing_beam_pos.each do |(pos, timeline_count)|
    new_pos = lower_pos(pos)

    case @map[new_pos]
    when '.'
      ongoing_pos[new_pos] ||= 0
      ongoing_pos[new_pos] += timeline_count
    when '^'
      left_pos, right_pos = split_beam(new_pos)
      ongoing_pos[left_pos] ||= 0
      ongoing_pos[left_pos] += timeline_count
      ongoing_pos[right_pos] ||= 0
      ongoing_pos[right_pos] += timeline_count
    end
  end
  break if ongoing_pos.empty?
  ongoing_beam_pos = ongoing_pos
end

puts ongoing_beam_pos.values.sum
