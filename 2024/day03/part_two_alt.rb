# frozen_string_literal: true

all_regex = /mul\(\d+,\d+\)/
excl_regex = /don't\(\).+?do\(\)|don't\(\).+\z/

File
  .read('input.txt')
  .delete!("\n")
  .gsub(excl_regex, '')
  .scan(all_regex)
  .sum { |match| match.gsub(/\d+/).map(&:to_i).inject(:*) }
