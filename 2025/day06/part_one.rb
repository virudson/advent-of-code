lines = File
          .readlines(File.join(File.dirname(__FILE__), 'input.txt'))
          .map { it.strip.split(/\s+/) }
          .transpose

result = lines.sum do
  operator = it.pop
  it.map(&:to_i).inject(&operator.to_sym)
end

puts result
