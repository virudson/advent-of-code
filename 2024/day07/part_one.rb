# frozen_string_literal: true

File.readlines('input.txt').sum do |line|
  result, nums = line.split(': ')
  result = result.to_i
  nums = nums.split("\s").map(&:to_i)

  is_match = %i[+ *].repeated_permutation(nums.size - 1).any? do |operator_list|
    value = nums.each.with_index.inject(0) do |sum, (num, idx)|
      idx.zero? ? num : sum.send(operator_list[idx - 1], num)
    end
    value == result
  end
  is_match ? result : 0
end