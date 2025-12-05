list = File.readlines(File.join(File.dirname(__FILE__), 'input.txt'))
DAIL_SIZE = 100
current_dial = 50
zero_count = 0
pass_zero_count = 0

puts "The dial starts by pointing at #{current_dial}."
list.each do
  direction, size = [it[0], it[1..].to_i]
  left_over = direction == "L" ? current_dial - (size % 100) : current_dial + (size % 100)
  pass_zero = (size / 100).floor
  pass_zero += left_over.between?(0, 99) ? 0 : 1
  pass_zero -= 1 if current_dial.zero?
  pass_zero_count += pass_zero

  current_dial = (direction == "L" ? current_dial - size : current_dial + size) % 100

  print "The dial is rotated #{it.strip} to point at #{current_dial}"
  puts "." unless pass_zero.positive?
  puts ", during this rotation, it points at 0: #{pass_zero}." if pass_zero.positive?
end

puts "The password in this example is #{zero_count + pass_zero_count} (#{zero_count} + #{pass_zero_count})."
