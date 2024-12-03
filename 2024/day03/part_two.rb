# frozen_string_literal: true

cmd_regex = /don't\(\)|do\(\)|mul\(\d+,\d+\)/

enabled = true
File
  .read('input.txt')
  .scan(cmd_regex)
  .sum do |match|
  case match
  when 'do()' then enabled = true; 0
  when "don't()" then enabled = false; 0
  else
    enabled ? match.gsub(/\d+/).map(&:to_i).inject(:*) : 0
  end
end
