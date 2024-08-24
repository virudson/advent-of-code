# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 15 - Part 2') do
    def box_number(str)
      str.chars.inject(0) { (_1 + _2.ord) * 17 % 256 }
    end

    input = File.read('input.txt').split(',')
    boxes = Hash.new { |h, k| h[k] = {} }
    input.each do |str|
      if str =~ /-/
        label = str[0..-2]
        number = box_number(label)
        boxes[number].delete(label)
      else
        label, value = str.split(/=/)
        number = box_number(label)
        boxes[number][label] = value.to_i
      end
    end
    boxes.sum do |(box_no, lens)|
      lens.values.each_with_index.sum do |value, index|
        (box_no + 1) * (index + 1) * value
      end
    end
  end
end
