# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 01 - Part 2') do
    sum = 0
    mapper = %w[one two three four five six seven eight nine].zip([*1..9]).to_h
    #  => {"one"=>1, "two"=>2, "three"=>3, "four"=>4, "five"=>5, "six"=>6, "seven"=>7, "eight"=>8, "nine"=>9}
    reverse_mapper = mapper.keys.map(&:reverse).zip([*1..9]).to_h
    #  => {"eno"=>1, "owt"=>2, "eerht"=>3, "ruof"=>4, "evif"=>5, "xis"=>6, "neves"=>7, "thgie"=>8, "enin"=>9}

    File.foreach('input.txt') do |line|
      # replace from front then filter only digits
      front_digits = line.gsub(/(#{mapper.keys.join('|')})/, mapper).tr('^1-9', '')

      # replace from back then filter only digits
      back_digits = line
                       .reverse
                       .gsub(/(#{reverse_mapper.keys.join('|')})/, reverse_mapper)
                       .tr('^1-9', '')

      # get first digits and from front and back
      sum += (front_digits[0] + back_digits[0]).to_i
    end
    # puts "Calibration value is: #{sum}"
  end
end
