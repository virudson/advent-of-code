locations = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
                .split("\n")
                .map { it.split(',').map(&:to_i) }
# find largest
largest_area = 0
locations.each do |p1|
  locations.each do |p2|
    next if p1 == p2

    x1, y1 = p1
    x2, y2 = p2

    area = ((x2 - x1).abs + 1) * ((y2 - y1).abs + 1)
    largest_area = area if area > largest_area
  end
end

puts largest_area
