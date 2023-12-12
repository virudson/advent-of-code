# frozen_string_literal: true

require 'benchmark'

Benchmark.bmbm do |x|
  x.report('Day 08 - Part 1') do
    final_destination = 'ZZZ'
    instructions = { 'L' => 0, 'R' => 1 }

    input_data = File.read('input.txt').split("\n\n")
    routes = input_data[0]
    nodes = input_data[1].scan(/\w{3}/).each_slice(3).each_with_object({}) do |node, hash|
      hash[node[0]] = node[1..]
    end

    cur_node_name = 'AAA'
    round = 0
    while cur_node_name != final_destination do
      routes.chars.each do |path|
        current_node = nodes[cur_node_name]
        des_node_name = current_node[instructions[path]]
        puts "From #{cur_node_name} move to #{path} => #{des_node_name}"
        round += 1
        cur_node_name = des_node_name
        break if des_node_name == final_destination
      end
    end
    puts "Total steps from AAA to ZZZ is: #{round}"
  end
end
