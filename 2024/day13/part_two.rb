# frozen_string_literal: true

# This is a math problem definitely NOT my forte
# I HATE MATH!!
# Btw thanks to math ppl in this world that make me sleep tight today

PRESS_LIMIT = 100
ADDITIONAL = 10_000_000_000_000

machines = File.read('input.txt').gsub(/\d+/).map(&:to_f)

chips = machines.each_slice(6).map do |(ax, ay, bx, by, px, py)|
  px += ADDITIONAL
  py += ADDITIONAL

  total_a = ((py - (px * by / bx)) / (ay - (ax * by / bx)))
  total_b = ((px - ax * total_a) / bx)

  # a bit round check seem it almost be an integer
  next if [total_a, total_b].any? { (_1.round(2) % 1) != 0 }

  ((3 * total_a.round) + total_b.round)
end

puts chips.compact.sum
