# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|

  x.report('Day 04 - Part 1') do
    # return destination map to source else return nil
    # input = 51, mapper = [50, 98, 3]
    # => 99
    #
    # input = 70, mapper = [50, 98, 3]
    # => nil
    def get_destination(input, code)
      d, s, r = *code
      s_map = s..(s + r - 1)
      # d_map = d..(d + r - 1)

      s_map.cover?(input) ? d + (input - s) : nil
    end

    def find_min(input, mappers)
      result = mappers.map { |mapper| get_destination(input, mapper) }
      # puts "==========Start Mapper (#{input})========="
      # puts "Result: #{result} MIN: #{ result.any? ? result.compact.min : input}"
      result.any? ? result.compact.min : input
    end

    input_data = File.read('input.txt').split("\n\n")
    seed_data = input_data[0].gsub(/\d+/).map(&:to_i)
    all_mappers = input_data[1..-1].map do |mapper|
      mapper.gsub(/\d+/).map(&:to_i).each_slice(3).to_a
    end

    seed_data.map do |seed, hash|
      hash[seed] = all_mappers.map do |mapper|
        seed = find_min(seed, mapper)
      end.last
    end.min
  end
end
