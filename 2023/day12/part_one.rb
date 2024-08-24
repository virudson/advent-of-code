# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 12 - Part 1') do

    def mapper_for(pattern, regex)
      pattern.to_enum(:scan, regex).map do |match|
        index = Regexp.last_match.pre_match.size
        [index..(index + match.size - 1), match]
      end
    end

    def find_prop(pattern, rules)
      if pattern =~ /\?/
        [
          find_prop(pattern.sub('?', '.'), rules),
          find_prop(pattern.sub('?', '#'), rules)
        ].flatten.compact
      elsif rules == pattern.scan(/#+/).map(&:size)
        pattern
      end
    end

    patterns = File.readlines('input.txt', chomp: true)
    sum = patterns.sum do |line|
      # line = '#?..??.???##?.?? 2,1,1,3,1'
      puts "Finding #{line}"
      pattern, rules = line.split
      rules = rules.split(',').map(&:to_i)
      detector = pattern.scan(/[#?]+/).map(&:size)
      mappers = mapper_for(pattern, /[?#]+/)

      # cleanup the impossible
      if detector.size >= rules.size
        loop do
          break if detector[0] >= rules[0]

          mapper = mappers.shift
          pattern[mapper[0]] = '.' * mapper[1].size
          detector = pattern.scan(/[#?]+/).map(&:size)
        end
      end

      find_prop(pattern, rules).size
    end
    puts "Total sum of arrangement is: #{sum}"
  end
end
