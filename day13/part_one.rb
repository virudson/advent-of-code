# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 13 - Part 1') do
    def find_reflection(data)
      data_size = data.size - 1
      data_size.times.map do |index|
        l_side = data[0..index].reverse
        r_side = data[index + 1..]

        # create pair of left and right then select only have left and right
        checker = l_side.zip(r_side).select { !_1[1].nil? }
        l_side.size if checker.all? { _1 == _2 }
      end.compact[0]
    end

    input = File.read('input_demo.txt')
                .split("\n\n")
                .map { _1.split("\n") }
    input.sum do
      index = find_reflection(_1).to_i * 100 # find reflection at --
      index || find_reflection(_1.map(&:chars).transpose.map(&:join)) # find reflection at |
    end
  end
end
