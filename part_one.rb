# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 01 - Part 1') do
    sum = 0
    File.foreach('input.txt').each do |line|
      digits = line.tr('^1-9', '')
      sum += (digits[0] + digits[-1]).to_i
    end
    puts sum
  end
end
