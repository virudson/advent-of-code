lines = File.read(File.join(File.dirname(__FILE__), 'input.txt')).split(/\n/)
operators = lines.pop.split(/\s+/)
line_size = lines.map(&:size).max
lines = lines.map { ("%-#{line_size}s" % it).chars }
             .transpose
             .map { Integer(it.join.strip, exception: false) }

result = lines
           .slice_when { it.nil? }
           .zip(operators)
           .map { it.flatten!.compact }
           .sum do
  operator = it.pop
  it.map(&:to_i).inject(&operator.to_sym)
end

puts result
