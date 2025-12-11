@nodes = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
             .split("\n")
             .each_with_object({}) do |line, hash|
  line.gsub(/\w+/).to_a.yield_self { |devices| hash[devices[0]] = devices[1..] }
end

def travel(node, visited = [])
  visited << node
  return 1 if node == "out"

  @nodes[node].sum { |next_node| travel(next_node, visited.dup) }
end

puts travel('you')
