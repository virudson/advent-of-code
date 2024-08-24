# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 03 - Part 1') do
    # return array of indexes of numbers
    # [ [start_index_digit, end_index_digits, numbers], [...], ... ]
    def detect_number(string)
      string.to_enum(:scan, /\d+/).map do |match|
        # "$`" -> string before matched string.
        # "$`.size" -> size of string before match.
        # for example
        # "467..114.." will found 2 matches
        # 1) $` = ""      / $`.size = 0 / match = '467'
        # 2) $` = "467.." / $`.size = 5 / match = '114'

        [$`.size, $`.size + match.size - 1, match.to_i]
      end
    end

    # return array of indexes of symbols
    # [ [start_index_symbol - 1, end_index_symbol + 1], [...], ... ]
    def detect_symbol(string)
      string.to_enum(:scan, /[^\w.]/).map do |match|
        # "$`" -> string before matched string.
        # "$`.size" -> size of string before match.
        # for example
        # "123..?..114.." will found 1 match
        # 1) $` = "123.." / $`.size = 5 / match = '?'

        [$`.size - 1, $`.size + match.size]
      end
    end

    def clean_line(line, start_idx, end_idx)
      line[start_idx..end_idx] = '.' * (end_idx + 1 - start_idx)
    end

    def overlap?(symbol_map, number_map)
      symbol_map[0] <= number_map[1] && number_map[0] <= symbol_map[1]
    end

    def find_part(upper, middle, lower)
      ratio = 0
      symbol_mapper = detect_symbol(middle)
      upper_num_map = detect_number(upper)
      middle_num_map = detect_number(middle)
      lower_num_map = detect_number(lower)

      # find all numbers around the symbol
      symbol_mapper.each do |s_map|
        up_map = upper_num_map.select { |n_map| overlap?(s_map, n_map) }
        mid_map = middle_num_map.select { |n_map| overlap?(s_map, n_map) }
        low_map = lower_num_map.select { |n_map| overlap?(s_map, n_map) }

        # Replace used numbers
        up_map.each { |n_map| clean_line(upper, n_map[0], n_map[1]) }
        mid_map.each { |n_map| clean_line(middle, n_map[0], n_map[1]) }
        low_map.each { |n_map| clean_line(lower, n_map[0], n_map[1]) }

        # Calculate ratio
        ratio += (up_map + mid_map + low_map).map(&:last).sum
      end
      ratio
    end

    sum = 0
    upper_line = nil
    middle_line = nil
    lower_line = nil

    File.foreach('input.txt', chomp: true) do |line|
      # rotate new line from bottom
      upper_line = middle_line
      middle_line = lower_line
      lower_line = line

      # detect symbol at middle line
      next unless middle_line =~ /[^\w.]/

      # process adjacent line when middle line have symbol
      sum += find_part(upper_line, middle_line, lower_line)
    end

    # puts "Sum of part numbers in the engine is: #{sum}"
  end
end
