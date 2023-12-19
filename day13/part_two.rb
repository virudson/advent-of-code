# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 13 - Part 2') do
    def find_reflection(data)
      data_size = data.size - 1
      data_size.times.map do |index|
        l_side = data[0..index].reverse
        r_side = data[index + 1..]
        # filter only array that have pair left and right
        checker = l_side.zip(r_side).reject { _1[1].nil? }

        # create pair again compare left & right
        # if found only one 1 unmatched (smudge)
        mismatch = checker.sum do |left, right|
          left.zip(right).select { _1 != _2 }.size
        end
        l_side.size if mismatch == 1
      end.compact[0]
    end

    input = File.read('input.txt')
                .split("\n\n")
                .map { _1.split("\n").map(&:chars) }
    input.sum do
      index = find_reflection(_1.transpose) # find reflection at |
      index || find_reflection(_1) * 100 # find reflection at --
    end
  end
end
