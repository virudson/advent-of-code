# frozen_string_literal: true

def get_value(list)
  is_valid = list.all? do |num|
    define_rules = @rules[num] || []
    define_rules.all? do |rule|
      rule_index = list.find_index(rule)
      rule_index.nil? ? true : list.find_index(num) < rule_index
    end
  end
  return 0 if is_valid

  list = sort(list)
  list[list.size / 2]
end

def sort(list)
  list.sort do |a, b|
    a_rules = @rules[a] || []
    b_rules = @rules[b] || []

    if a_rules.include?(b)
      -1
    elsif b_rules.include?(a)
      1
    else
      0
    end
  end
end

rules, printed_list = File.read('input.txt').split("\n\n")
@rules = rules.split("\n").each_with_object({}) do |rule, hash|
  before, after = rule.split('|').map(&:to_i)
  hash[before] ||= []
  hash[before] << after
end

printed_list
  .split("\n")
  .map { |list| list.split(',').map(&:to_i) }
  .sum { |list| get_value(list) }
