# frozen_string_literal: true

regex = /mul\((\d+,\d+)\)/

File
  .read('input.txt')
  .scan(regex)
  .flatten
  .sum { |match| match.split(",").map(&:to_i).inject(:*) }
