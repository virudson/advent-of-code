# frozen_string_literal: true

require 'benchmark'
Benchmark.bmbm do |x|
  x.report('Day 19 - Part 2') do
    def create_map(conditions)
      map = {}
      conditions[0..-2].each do |condition|
        map[name] ||= Hash.new { |h, k| h[k] = {} }
        map[name] = condition.last
      end
    end

    @map = Hash.new { |h, k| h[k] = {} }
    @inputs = { 'x' => [], 'm' => [], 'a' => [], 's' => [1, 4000] }
    workflows, = File.read('input_demo.txt', chomp: true).split("\n\n")
    workflows = workflows.split("\n").map do |line|
      name, str = line.gsub(/(\w+)\{(.+)\}/).flat_map { [$1, $2] }
      conditions = str.split(',').map do |str|
        if str =~ /(\w+)([<>])(\d+):(\w+)/
          str.gsub(/(\w+)([<>])(\d+):(\w+)/).flat_map { [$1, $2.to_sym, $3.to_i, $4] }
        else
          str
        end
      end
      [name, conditions]
    end.to_h

  end
end
