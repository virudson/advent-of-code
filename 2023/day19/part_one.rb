# frozen_string_literal: true

require 'benchmark'
Benchmark.bmbm do |x|
  x.report('Day 19 - Part 1') do
    def process(values, conditions)
      conditions[0..-2].each do |str|
        key, con, value, c_name = str.gsub(/(\w+)([<>])(\d+):(\w+)/)
                                     .flat_map { [$1, $2.to_sym, $3.to_i, $4] }
        return p c_name if values[key]&.send(con, value)
      end
      conditions.last
    end

    workflows, inputs = File.read('input.txt', chomp: true).split("\n\n")
    workflows = workflows.split("\n").map do |line|
      name, str = line.gsub(/(\w+)\{(.+)\}/).flat_map { [$1, $2] }
      [name, str.split(',')]
    end.to_h
    inputs = inputs.split("\n").map do
      _1.gsub(/(\w+)=(\d+)/).map { [$1, $2.to_i] }
    end.map(&:to_h)

    inputs.sum do |input|
      result = 'in'
      until %w[A R].include?(result)
        result = process(input, workflows[result])
        puts result
      end
      result == 'A' ? input.values.sum : 0
    end
  end
end
