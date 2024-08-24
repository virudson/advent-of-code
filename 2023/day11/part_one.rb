# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 11 - Part 1') do
    def fill_space(array_2d)
      indexes = array_2d.map.with_index do |line, index|
        index unless line.join =~ /#/
      end
      indexes.compact.each_with_index do |row, index|
        array_2d.insert(index + row, ('.' * array_2d[0].size).chars)
      end
      array_2d
    end

    universe = File.readlines('input_demo.txt', chomp: true).map(&:chars)
    universe = fill_space(universe)
    universe = fill_space(universe.transpose).transpose
    galaxies = universe.flat_map.with_index do |line, row|
      line.join.enum_for(:scan, /#/).map { [row, Regexp.last_match.offset(0).first] }
    end

    shortest_path = galaxies.each_with_object({}).with_index do |(from, hash), f_idx|
      galaxies[(f_idx + 1)..].each.with_index(f_idx + 1) do |to, t_idx|
        key = [t_idx + 1, f_idx + 1].sort.join('/')
        hash[key] = (from[0] - to[0]).abs + (from[1] - to[1]).abs
      end
    end
    puts "Sum of shortest path of galaxies is: #{shortest_path.values.sum}"
  end
end
