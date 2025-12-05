list = File.read(File.join(File.dirname(__FILE__), 'input.txt')).split(',')

sum_invalid = 0

list.each do
  from, to = it.split("-").map(&:to_i)
  from.upto(to) do |i|
    str = i.to_s

    2.upto(str.size) do |split_size|
      next if (str.size % split_size).nonzero?
      next if str.scan(/.{1,#{str.size / split_size}}/).uniq.size > 1

      sum_invalid += i
      break
    end
  end
end

puts sum_invalid
