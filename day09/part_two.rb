# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 09 - Part 1') do
    sum = 0
    File.foreach('input.txt') do |line|
      timeline = []
      timeline << line.scan(/-?\d+/).map(&:to_i)
      until timeline[-1].all?(&:zero?)
        current = timeline[-1]
        timeline << (current.size - 1).times.map do |index|
          current[index + 1] - current[index]
        end
      end

      # fill up history
      timeline.reverse!
      prediction = 0
      result = (timeline.size - 1).times.map do |index|
        prediction = timeline[index + 1][0] - prediction
      end
      sum += result.last
    end
    # puts "Sum of extrapolated values is #{sum}"
  end
end
