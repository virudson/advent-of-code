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
      string.to_enum(:scan, /[^\w.\n]/).map do |match|
        # "$`" -> string before matched string.
        # "$`.size" -> size of string before match.
        # for example
        # "123..?..114.." will found 1 match
        # 1) $` = "123.." / $`.size = 5 / match = '?'

        [$`.size - 1, $`.size + match.size, string[($`.size - 1)..($`.size + match.size)]]
      end
    end

    def find_parts(main_line, compare_line)
      sum_parts = 0
      symbol_mapper = detect_symbol(main_line)
      number_mapper = detect_number(compare_line)

      number_mapper.each_with_index do |n_map, index|
        n_start = n_map[0]
        n_end = n_map[1]

        symbol_mapper.each do |s_map|
          s_start = s_map[0]
          s_end = s_map[1]

          # check even diagonally
          next unless s_start <= n_end && n_start <= s_end

          # sum matched then cleanup matches then remove number from n_mapper
          sum_parts += n_map[2]
          compare_line[n_start..n_end] = '.' * (n_end + 1 - n_start)
        end
      end
      sum_parts
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

      # match when symbol adjacent to digit
      sum += find_parts(lower_line, lower_line) if lower_line =~ /\d?[^\w.]|[^\w.]\d?/
      next unless middle_line =~ /[^\w.]/

      # process adjacent line when middle line have symbol
      sum += find_parts(middle_line, upper_line) if upper_line =~ /\d+/
      sum += find_parts(middle_line, lower_line) if lower_line =~ /\d+/
    end

    puts "Sum of part numbers in the engine is: #{sum}"
  end
end
