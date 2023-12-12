# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 08 - Part 2') do
    input_data = File.read('input.txt').split("\n\n")
    routes = input_data[0]
    start_nodes = []
    nodes = input_data[1].scan(/\w{3}/).each_slice(3).each_with_object({}) do |node, hash|
      start_nodes << node[0] if node[0] =~ /A$/
      hash[node[0]] = node[1..]
    end

    result = []
    start_nodes.each_with_index do |node_name, index|
      round = 0
      cur_node_name = node_name

      while true do
        routes.chars.each do |path|
          current_node = nodes[cur_node_name]
          des_node_name = current_node[path == ?L ? 0 : 1]
          start_nodes[index] = des_node_name
          cur_node_name = des_node_name
          round += 1
          break if cur_node_name =~ /Z$/
        end

        if cur_node_name =~ /Z$/
          result[index] << round
          break
        end
      end
    end
    # puts "Total steps from all ??A to ??Z is: #{result.inject(&:lcm)}"
  end
end
