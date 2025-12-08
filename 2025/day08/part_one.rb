locations = File.read(File.join(File.dirname(__FILE__), 'input.txt')).split("\n")

# generate map
@distances = locations.each_with_object({}) do |p1, hash|
  locations.each do |p2|
    next if p1 == p2

    key = [p1, p2].sort.join("|")
    x1, y1, z1 = p1.split(',').map(&:to_i)
    x2, y2, z2 = p2.split(',').map(&:to_i)

    hash[key] = Math.sqrt(((x2 - x1) ** 2) + ((y2 - y1) ** 2) + ((z2 - z1) ** 2))
  end
end

round = 0
circuits = []

@distances.to_a.sort_by(&:last).each do |key, _|
  break if round == 1_000
  round += 1

  p1, p2 = key.split('|')

  p1_index = circuits.index { it.include?(p1) }
  p2_index = circuits.index { it.include?(p2) }

  # both exists same group (do nothing)
  next if (p1_index && p2_index) && (p1_index == p2_index)

  # never exists
  if [p1_index, p2_index].all?(&:nil?) # both not exists (create)
    circuits << Set.new([p1, p2])
  elsif p1_index && p2_index # both exists but different group (merge)
    circuits[p1_index].merge(circuits[p2_index])
    circuits.delete_at(p2_index)
  else
    # only one exists (add another to existing one)
    circuits[p1_index].add(p2) if p1_index
    circuits[p2_index].add(p1) if p2_index
  end
end

puts circuits.map(&:size).sort.last(3).inject(:*)
