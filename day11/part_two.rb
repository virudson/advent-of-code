# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 11 - Part 2') do
    def find_space(array_2d)
      array_2d.map.with_index(0) do |line, index|
        index unless line.join =~ /#/
      end.compact
    end

    universe = File.readlines('input.txt', chomp: true).map(&:chars)
    space_rows = find_space(universe)
    space_cols = find_space(universe.transpose)
    galaxies = universe.flat_map.with_index(0) do |line, row|
      line.join.enum_for(:scan, /#/).map { [row, Regexp.last_match.offset(0).first] }
    end

    shortest_path = galaxies.each_with_object({}).with_index(0) do |(from, hash), f_idx|
      galaxies[(f_idx + 1)..].each.with_index(f_idx + 1) do |to, t_idx|
        key = [t_idx + 1, f_idx + 1].sort.join('/')
        next if hash[key]

        path = [from, to].transpose.map(&:sort!)
        hash[key] = (from[0] - to[0]).abs + (from[1] - to[1]).abs
        space_count = space_rows.select { |space| (path[0][0]..path[0][1]).cover?(space) }.size
        space_count += space_cols.select { |space| (path[1][0]..path[1][1]).cover?(space) }.size
        hash[key] += (space_count * 1_000_000) - space_count
      end
    end
    puts "Sum of shortest path of galaxies is: #{shortest_path.values.sum}"
  end
end
