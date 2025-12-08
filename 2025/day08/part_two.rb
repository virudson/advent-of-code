locations = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
                .split("\n")
                .map { it.split(',').map(&:to_i) }

# generate map
@distances = locations.each_with_object({}) do |p1, hash|
  locations.each do |p2|
    next if p1 == p2

    x1, y1, z1 = p1
    x2, y2, z2 = p2
    hash[[p1, p2].sort] = Math.sqrt(((x2 - x1) ** 2) + ((y2 - y1) ** 2) + ((z2 - z1) ** 2))
  end
end

circuits = []

@distances.to_a.sort_by(&:last).each do |key, _|
  p1, p2 = key

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

  if circuits.size == 1 && circuits[0].size == locations.size
    puts "Circuit completed at connection #{p1[0]} and #{p2[0]}"
    puts p1[0] * p2[0]
    break
  end
end
