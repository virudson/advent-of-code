# frozen_string_literal: true

def get_value(list)
  is_valid = list.all? do |num|
    define_rules = @rules[num]
    if define_rules
      define_rules.all? do |rule|
        rule_index = list.find_index(rule)
        rule_index.nil? ? true : list.find_index(num) < rule_index
      end
    else
      true
    end
  end

  is_valid ? list[list.size / 2] : 0
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
