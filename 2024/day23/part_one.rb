# frozen_string_literal: true

lan = File.read('input.txt').split("\n").map { _1.split('-') }
pc_lan = lan.each_with_object({}) do |(pc1, pc2), hash|
  hash[pc1] ||= []
  hash[pc1] << pc2
  hash[pc2] ||= []
  hash[pc2] << pc1
end

networks = lan.each_with_object(Set.new) do |(pc1, pc2), group|
  common = pc_lan[pc1] & pc_lan[pc2]
  next if common.empty?

  common.each { group.add([pc1, pc2, _1].sort) }
end

networks.sum { _1.any? { |pc| pc.start_with?('t') } ? 1 : 0 }
