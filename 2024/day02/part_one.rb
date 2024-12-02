safety_check = lambda do |array|
  return false if array.uniq.size < array.size

  sorted = array.sort
  return false unless array == sorted || array == sorted.reverse

  sorted.each_cons(2).all? { |(first, last)| last - first <= 3 }
end

File
  .readlines('input.txt')
  .map { |line| safety_check.call(line.split("\s").map(&:to_i)) }
  .sum { |safety| safety ? 1 : 0 }
