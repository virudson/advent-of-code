# frozen_string_literal: true
# frozen_string_literal: tru

@data = File.read('input.txt').split("\n").map(&:chars)

def find_xmas(row, col)
  words = [[[-1, -1], [1, 1]], [[1, -1], [-1, 1]]].map do |directions|
    directions.map do |dir|
      row_at = row + 1 * dir[0]
      col_at = col + 1 * dir[1]
      is_overflow = [row_at, col_at].any?(&:negative?) || row_at >= @data.size || col_at >= @data[0].size
      is_overflow ? nil : @data[row_at][col_at]
    end
  end.map(&:join)
  words.all? { |word| word == 'MS' || word == 'SM' } ? 1 : 0
end

@data.map.with_index do |line, row|
  line.map.with_index { |char, col| char == 'A' ? find_xmas(row, col) : 0 }.sum
end.sum
