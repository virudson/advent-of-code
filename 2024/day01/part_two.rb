left, right = File.readlines('input.txt')
                  .map { |line| line.split("\s").map(&:to_i) }
                  .transpose
counter = left.uniq.each_with_object(Hash.new(0)) { |key, hash| hash[key.to_s] = 0 }
right.each { |r| counter[r.to_s] += 1 }
left.sum { |l| l * counter[l.to_s] }
