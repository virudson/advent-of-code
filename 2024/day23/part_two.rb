# frozen_string_literal: true

def circle_network?(nodes, networks)
  nodes.combination(2).all? do |(n1, n2)|
    n1 == n2 || (networks[n1] & networks[n2]).sort == (nodes - [n1, n2]).sort
  end
end

lan = File.read('input.txt').split("\n").map { _1.split('-') }
networks = lan.each_with_object({}) do |(n1, n2), hash|
  hash[n1] ||= []
  hash[n1] << n2
  hash[n2] ||= []
  hash[n2] << n1
end

group = []
networks.each do |node, connected|
  # skip when largest possible is less than found group
  next if connected.empty? || group.size > connected.size + 1

  nodes = connected + [node]
  nodes.size.downto(2) do |size|
    # skip when largest possible is less than found group
    break if group.size > size

    possible_list = nodes.combination(size).map(&:sort).uniq
    possible_list.each do |sample_nodes|
      next unless circle_network?(sample_nodes, networks)

      # assign found group then skip this node size
      group = sample_nodes
      break
    end
  end
end

puts group.sort.join(',')
