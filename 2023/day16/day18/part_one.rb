# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 17 - Part 1') do

    def heat(x, y, direction, step)
      tx, ty = @directions[direction].zip([x, y]).map(&:sum)

      case direction
      when 'R'
        @fields[tx][ty..(ty + step - 1)]
      when 'L'
        @fields[tx][(ty - step + 1)..ty]
      when 'D'
        @fields.transpose[ty][tx..(tx + step - 1)]
      when 'U'
        @fields.transpose[ty][(tx - step + 1)..(tx)]
      end
    end

    def move_to(x, y, direction, cache = Set.new)
      cache.add([x, y])
      @next[direction].each do |dir|
        1.upto(3).each do |step|
          tx, ty = @directions[dir]
                     .zip([step, step])
                     .map { _1.inject(&:*) }
                     .zip([x, y])
                     .map(&:sum)
          next if tx < 0 || ty < 0 || tx >= @rows || ty >= @cols # outside grid

          heat_loss = heat(x, y, dir, step)
        end
      end
    end

    @next = { 'U' => %w[L R], 'D' => %w[L R], 'L' => %w[U D], 'R' => %w[U D] }
    @directions = { 'U' => [-1, 0], 'D' => [1, 0], 'L' => [0, -1], 'R' => [0, 1] }
    @fields = File.readlines('input_demo.txt', chomp: true).map { _1.chars.map(&:to_i) }
    @rows = @fields.size
    @cols = @fields[0].size

    [[0, 0, 'R'], [0, 0, 'D']]
  end
end
