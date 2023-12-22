# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 15 - Part 1') do
    input = File.read('input.txt').split(',')
    input.sum do |str|
      str.chars.inject(0) { (_1 + _2.ord) * 17 % 256 }
    end
  end
end
