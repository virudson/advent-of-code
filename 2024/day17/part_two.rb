# frozen_string_literal: true

# reverse engineer
# 1) [2, 4]: B = A % 8        0-7
# 2) [1, 1]: B = B ^ 1        B is within 0-7
# 3) [7, 5]: C = A / 2**B     C = A / one of [1, 2, 4, 8, 16, 32, 64, 128]
# 4) [4, 6]: B = B ^ C
# 5) [1, 4]: B = B ^ 4.       B = B ^ C ^ 4
# 6) [0, 3]: A = A / 8        Reduce A
# 7) [5, 5]: print B % 8      show B % 8
# 8) [3, 0]: LOOP if A != 0.

# shorter version of input program
def run(a)
  result = []
  loop do
    b = (a % 8) ^ 1
    c = a / 2 ** b
    b ^= c ^ 4
    a /= 8
    result << b % 8
    return result if a.zero?
  end
  result
end

# just focus only output
def show(a)
  b = (a % 8) ^ 1
  c = a / 2 ** b
  b ^= c ^ 4
  b % 8
end

def find(a, index)
  return if show(a) != @expected[index]

  if index.zero?
    @result << a
  else
    # since output can only 0-7 from and A divines by 8 every time exec output
    8.times { |b| find((a * 8) + b, index - 1) }
  end
end

_, programs = File.read('input.txt').split("\n\n")
@expected = programs.gsub(/\d/).map(&:to_i)

# min_size =  35184372088832
# max_size = 281474976710655
@result = []

# all possible 0-7 finding each index (start from the back)
8.times { |a| find(a, @expected.size - 1) }
@result.min
