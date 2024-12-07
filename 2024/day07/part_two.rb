# frozen_string_literal: true

File.readlines('input.txt').sum do |line|
  result, nums = line.split(': ')
  result = result.to_i
  dataset = nums.split("\s").map(&:to_i)

  is_match = %i[+ * |].repeated_permutation(dataset.size - 1).any? do |operators|
    nums = dataset.clone
    operator_list = operators.clone

    value = nums.each.with_index.inject(0) do |sum, (num, idx)|
      operator = idx.zero? ? nil : operator_list[idx - 1]
      case operator
      when :+ then sum + num
      when :* then sum * num
      when :| then "#{sum}#{num}".to_i
      else
        num
      end
    end
    value == result
  end

  is_match ? result : 0
end
