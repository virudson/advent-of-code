# frozen_string_literal: true

nodes = Hash.new { |h, k| h[k] = [] }
map = File.read('input.txt').split("\n").map.with_index do |line, row|
  line.chars.map.with_index do |char, col|
    nodes[char] << [row, col] if char != '.'
    char
  end
end

anti_nodes = Set.new

nodes.each_value do |pos_list|
  pos_list.permutation(2).each do |(pos_a, pos_b)|
    diff = [pos_a, pos_b].transpose.map { _1.inject(:-) }
    x, y = pos_a
    anti_nodes.add(pos_a)

    loop do
      x, y = [x, y].zip(diff).map(&:sum)
      break if [x, y].any?(&:negative?) || x >= map.size || y >= map[0].size

      anti_nodes.add([x, y])
    end
  end
end

anti_nodes.size
