# frozen_string_literal: tru

@data = File.read('input.txt').split("\n").map(&:chars)

def find_word(row, col, keyword = 'XMAS')
  # { r: [0, 1], br: [1, 1], b: [1, 0], bl: [1, -1], l: [0, -1], tl: [-1, -1], t: [-1, 0], tr: [-1, 1] }
  [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]
    .sum do |(row_direction, col_direction)|
    word = keyword.size.times.map do |i|
      row_at = row + (i * row_direction)
      col_at = col + (i * col_direction)
      is_overflow = [row_at, col_at].any?(&:negative?) || row_at >= @data.size || col_at >= @data[0].size

      is_overflow ? nil : @data[row_at][col_at]
    end.join
    word == keyword || word == keyword.reverse ? 1 : 0
  end
end

@data
  .map.with_index do |line, row|
  line
    .map.with_index { |char, col| char == 'X' ? find_word(row, col) : 0 }
    .sum
end.sum