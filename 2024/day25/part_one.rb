# frozen_string_literal: true

locks, keys = File.read('input.txt').split("\n\n").each_with_object([[], []]) do
  data = _1.split("\n").map(&:chars)
  data[0].all? { |char| char == '#' } ? _2[0] << data : _2[1] << data
end
lock_pins = locks.map { |lock| lock.transpose.map { |l| l.sum { _1 == '#' ? 1 : 0 } } }

keys.sum do |key|
  key_pin = key.transpose.map { |line| line.sum { _1 == '#' ? 1 : 0 } }
  lock_pins.map.with_index do |lock_pin, index|
    key_pin.zip(lock_pin).map(&:sum).all? { _1 <= locks[index].size } ? 1 : 0
  end.sum
end
