lines = File.read(File.join(File.dirname(__FILE__), 'input.txt'))
            .split(/\n/)
            .map { it.reverse.chars }
            .transpose
            .map(&:join)

result = 0
stacks = []

lines.each do |line|
  next if line[..-2].to_i == 0
  stacks << line[..-2].to_i
  next if line[-1] == ' '

  result += stacks.inject(line[-1].to_sym)
  stacks.clear
end

puts result
