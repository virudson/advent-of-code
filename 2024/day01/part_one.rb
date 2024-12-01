list = File.readlines('input.txt')
           .map { |line| line.split("\s").map(&:to_i) }
           .transpose
           .map(&:sort)
           .transpose
list.sum { |(left, right)| (right - left).abs }
