AROUND_POS = [-1, 0, 1].repeated_permutation(2).to_a.freeze

paper_map = File
              .readlines(File.join(File.dirname(__FILE__), 'input.txt'))
              .each_with_object({}).with_index do |(line, hash), x|
  0.upto(line.strip.size - 1) { |y| hash[[x, y]] = line[y] if line[y] == '@' }
end

total_remove = 0
loop do
  remove_pos = paper_map.map do |(pos, _)|
    around_paper = AROUND_POS.sum do
      new_pos = [it, pos].transpose.map(&:sum)

      if new_pos == pos
        0
      else
        paper_map[new_pos] == '@' ? 1 : 0
      end
    end

    if around_paper < 4
      puts "Paper around #{pos}: #{around_paper}"
      pos
    end
  end.compact
  total_remove += remove_pos.size
  remove_pos.each { |pos| paper_map.delete(pos) }
  break if remove_pos.size.zero?
end

puts total_remove
