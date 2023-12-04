# frozen_string_literal: true

require 'benchmark'

mapper = %w[one two three four five six seven eight nine].zip([*1..9]).to_h
#  => {"one"=>1, "two"=>2, "three"=>3, "four"=>4, "five"=>5, "six"=>6, "seven"=>7, "eight"=>8, "nine"=>9}
reverse_mapper = mapper.keys.map(&:reverse).zip([*1..9]).to_h
#  => {"eno"=>1, "owt"=>2, "eerht"=>3, "ruof"=>4, "evif"=>5, "xis"=>6, "neves"=>7, "thgie"=>8, "enin"=>9}

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
