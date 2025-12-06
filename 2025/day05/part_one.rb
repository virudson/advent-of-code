fresh_ranges, ids = File
                      .read(File.join(File.dirname(__FILE__), 'test.txt'))
                      .split("\n\n")
                      .map.with_index do |text, idx|
  if idx.zero?
    text
      .split("\n")
      .map { Range.new(*it.split('-').map(&:to_i)) }
  else
    text.split("\n").map(&:to_i)
  end
end

fresh_count = ids.count { |id| fresh_ranges.any? { it.cover?(id) } }
puts fresh_count
