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

# return 2 pos around current_pos if possible
def split_beam(current_pos)
  [
    current_pos.zip([0, -1]).map(&:sum),
    current_pos.zip([0, 1]).map(&:sum)
  ].select { @map[it] == '.' }
end

splitter_pos = []
ongoing_beam_pos = [@map.key('S')]

loop do
  ongoing_pos = []

  ongoing_beam_pos.each do |current_pos|
    new_pos = lower_pos(current_pos)
    case @map[new_pos]
    when '.'
      @map[new_pos] = '|'
      ongoing_pos << new_pos
    when '^'
      splitter_pos << new_pos
      ongoing_pos += split_beam(new_pos)
    end
  end
  break if ongoing_pos.empty?
  ongoing_beam_pos = ongoing_pos.uniq
end

puts splitter_pos.size
