fresh_ranges = File
                 .read(File.join(File.dirname(__FILE__), 'input.txt'))
                 .split("\n\n")[0]
                 .split("\n")
                 .map { Range.new(*it.split('-').map(&:to_i)) }
                 .sort_by(&:min)

def merge_range(a, b)
  return unless a.overlap?(b)

  Range.new([a, b].map(&:min).min, [a, b].map(&:max).max)
end

current_ranges = fresh_ranges.dup

loop do
  is_merged = false
  1.upto(current_ranges.size - 1) do |index|
    new_range = merge_range(current_ranges[index -1], current_ranges[index])
    next unless new_range

    is_merged = true
    current_ranges.delete_at(index - 1)
    current_ranges.delete_at(index - 1)
    current_ranges << new_range
    current_ranges.sort_by!(&:min)
    break
  end

  break unless is_merged
end

puts current_ranges.map(&:size).sum
