# frozen_string_literal: true

def blink(stone)
  return '1' if stone == '0'
  return (stone.to_i * 2024).to_s if stone.size.odd?

  stone.chars.each_slice(stone.size / 2).map(&:join).map { _1.to_i.to_s }
end

stones = File.read('input.txt').split(' ')
25.times do
  stones = stones.map { blink(_1) }.flatten
end
stones.size
