FIXED_SIZE = 2
list = File.readlines(File.join(File.dirname(__FILE__), 'input.txt')).map(&:strip)

most_value_index = ->(str, found) do
  9.downto(0) do |num|
    index = str.index(num.to_s)
    next if index.nil?
    next if index > (str.size - 1) - (FIXED_SIZE - found.size - 1).abs

    return index
  end
end

sum = 0

list.each do |line|
  found = []
  current_index = 0

  loop do
    index = most_value_index.call(line[current_index..].to_s, found)

    if index
      found << index + current_index
      current_index = index + current_index + 1
    end
    break if found.size == FIXED_SIZE
  end

  max = found.map { line[it] }.join
  puts "In #{line}, you can make the largest joltage possible, #{max} from #{found}"
  sum += max.to_i
end

puts sum
