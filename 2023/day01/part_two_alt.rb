# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 01 - Part 2 (alternate solution)') do
    sum = 0
    mapper = %w[one two three four five six seven eight nine].zip([*1..9]).to_h
    specific_case = {
      'oneight' => 18,
      'twone' => 21,
      'threeight' => 38,
      'fiveight' => 58,
      'sevenine' => 79,
      'eightwo' => 82,
      'nineight' => 98
    }
    # The sample data already show special case so it's not cheating!! maybe :)

    File.foreach('input.txt') do |line|
      # replace matches for special case
      line.gsub!(/(#{specific_case.keys.join('|')})/, specific_case)

      # replace matching 1-9
      line.gsub!(/(#{mapper.keys.join('|')})/, mapper)

      # filter only digits
      digits = line.tr('^1-9', '')

      # get first and last then sum
      sum += (digits[0] + digits[-1]).to_i
    end

    # puts "Calibration value is: #{sum}"
  end
end

