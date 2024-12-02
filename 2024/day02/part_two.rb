def is_safe?(array)
  return false if array.uniq.size < array.size

  sorted = array.sort
  return false unless array == sorted || array == sorted.reverse

  sorted.each_cons(2).all? { |(first, last)| last - first <= 3 }
end

def safety_check(array)
  return true if is_safe?(array)

  array.size.times do |i|
    dup_array = array.dup
    dup_array.delete_at(i)
    return true if is_safe?(dup_array)
  end
  false
end

File
  .readlines('input.txt')
  .map { |line| safety_check(line.split("\s").map(&:to_i)) }
  .sum { |safety| safety ? 1 : 0 }
