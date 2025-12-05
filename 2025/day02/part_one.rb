list = File.read(File.join(File.dirname(__FILE__), 'input.txt')).split(',')

sum_invalid = 0

list.each do
  from, to = it.split("-").map(&:to_i)
  from.upto(to) do |i|
    str = i.to_s
    first, last = str.partition(/.{#{str.size / 2}}/)[1, 2]
    next if first != last

    sum_invalid += i
  end
end

puts sum_invalid
