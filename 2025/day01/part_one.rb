list = File.readlines(File.join(File.dirname(__FILE__), 'input.txt'))
DAIL_SIZE = 100
current_dial = 50
zero_count = 0

puts "The dial starts by pointing at #{current_dial}."
list.each do
  direction, size = [it[0], it[1..].to_i]
  current_dial = (direction == "L" ? current_dial - size : current_dial + size) % 100
  zero_count += 1 if current_dial.zero?

  puts "The dial is rotated #{it.strip} to point at #{current_dial}"
end

puts "The password in this example is #{zero_count}."
