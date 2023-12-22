# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 14 - Part 2') do
    # Gravity falling to left side
    def apply_gravity(input)
      input.map do |line|
        temp_line = line.join.split(/#/)
        temp_line.map! do |section|
          counter = section.chars.tally # count chars
          ('O' * counter['O'].to_i) + ('.' * counter['.'].to_i)
        end
        temp_line.join('#').ljust(line.size, '#').chars
      end
    end

    def show(str)
      puts str.map(&:join)
    end

    # rotate to the left 4 times
    def cycle(input)
      # north
      input = apply_gravity(input.transpose).transpose

      # west (normal input)
      input = apply_gravity(input)

      # south
      input = apply_gravity(input.transpose.map(&:reverse))
                .map(&:reverse)
                .transpose

      # east
      apply_gravity(input.map(&:reverse)).map(&:reverse)
    end

    input = File.readlines('input.txt', chomp: true).map(&:chars)
    cycle_count = 1_000_000_000
    cache = {}

    cycle_count.times do |index|
      input = cycle(input)

      # identify the cycle by store the result of cycle no
      key = input.map(&:join).join("\n")
      cache[key] ||= []
      cache[key] << index + 1

      next unless cache[key].size > 1

      # Find gap between last 2 cycle
      last_two_cycle = cache[key].last(2)
      inspect_cycle = last_two_cycle[1] - last_two_cycle[0] - 1

      # Check duplicate cycle is happened every N cycle
      break if ((cycle_count - index) % inspect_cycle).zero?
    end

    # rotate back for calculation
    rock_counter = input.map { |line| line.tally['O'].to_i }
    rock_counter.each_with_index.sum do |sum, index|
      sum * (input.size - index)
    end
  end
end
