# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 05 - Part 2') do
    # check range intersection
    def overlap?(range, range2)
      range.begin <= range2.end && range2.begin <= range.end
    end

    def find_destination(input, mappers)
      result = []
      pointer = input.begin
      mappers.each do |mapper|
        d, s, r = *mapper
        map_range = s..(s + r - 1)
        offset = d - s

        next unless overlap?(input, map_range)

        overlap_range = ([map_range.begin, input.begin].max)..([map_range.end, input.end].min)

        # add not overlap range if input range starts before mapper start
        result << (pointer..(overlap_range.begin - 1)) if input.begin > overlap_range.begin

        # map overlap range then add to result
        result << ((overlap_range.begin + offset)..(overlap_range.end + offset))

        # move pointer next to overlap range
        pointer = overlap_range.end + 1
      end

      # add leftover range that not match any mapper
      result << (pointer..input.end) if pointer < input.end
      result
    end

    input_data = File.read('input.txt').split("\n\n")

    # first line is always seed
    seed_data = input_data[0].scan(/\d+/)
                             .map(&:to_i)
                             .each_slice(2)
                             .map { |start, range| start..(start + range - 1) }

    # format mapper by set of 3 then sort it by begin of source
    all_mappers = input_data[1..].map do |mapper|
      mapper.scan(/\d+/).map(&:to_i).each_slice(3).to_a
    end
    all_mappers.map! { |mappers| mappers.sort_by { |mapper| mapper[1] } }

    result = all_mappers.inject(seed_data) do |seed, mappers|
      seed.flat_map do |input|
        find_destination(input, mappers)
      end
    end.min_by(&:begin)
    # puts "Lowest location number is: #{result.begin}"
  end
end
