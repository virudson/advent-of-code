# frozen_string_literal: true

def blink(stone)
  return @memory[stone] if @memory[stone]

  str = stone.to_s
  str_size = str.size
  result = if str_size.odd?
             stone * 2024
           else
             split_at = str_size / 2
             [str[0..(split_at - 1)].to_i, str[split_at..].to_i]
           end
  @memory[stone] = result
end

@memory = { 0 => 1 }
stone_counter = File
                  .read('input.txt')
                  .split(' ')
                  .map(&:to_i)
                  .each_with_object(Hash.new(0)) { _2[_1] += 1 }

75.times do
  # stones = stones.map { @memory[_1] || blink(_1) }.flatten
  stone_counter.to_a.each do |(number, qty)|
    result = @memory[number] || blink(number)
    stone_counter[number] -= qty

    if result.is_a?(Array)
      result.each { |num| stone_counter[num] += qty }
    else
      stone_counter[result] += qty
    end
  end
end

stone_counter.values.sum
