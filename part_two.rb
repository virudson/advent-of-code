# frozen_string_literal: true

require 'benchmark'

mapper = %w[one two three four five six seven eight nine].zip([*1..9]).to_h
reverse_mapper = mapper.keys.map(&:reverse).zip([*1..9]).to_h

Benchmark.bmbm do |x|
  x.report('Day 01 - Part 2') do
    sum = 0
    File.foreach('input.txt').each do |line|
      # replace only first match
      line.sub!(/(#{mapper.keys.join('|')})/, mapper)

      # reverse then replace only first one (last one)
      # then reverse line back
      line.reverse!
      line.sub!(/(#{reverse_mapper.keys.join('|')})/, reverse_mapper)
      line.reverse!

      # filter only digits
      digits = line.tr('^1-9', '')

      # get first and last then sum
      sum += (digits[0] + digits[-1]).to_i
    end
  end
end

puts "Calibration value is: #{sum}"
