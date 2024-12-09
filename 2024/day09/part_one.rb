# frozen_string_literal: true

storage = {}
file_blocks = []

File.open('input.txt') do |file|
  loop.with_index do |_, id|
    buffer = file.read(2)
    break if buffer.nil?

    data, free = buffer.gsub(/\d/).map(&:to_i)
    storage[id] = [data, free || 0, file_blocks.size]
    file_blocks += Array.new(data, id)
    file_blocks += Array.new(free || 0, '.')
  end
end

ary = file_blocks.clone

storage.reverse_each do |id, (data, _, start_idx)|
  is_done = false
  data.times do |i|
    index = ary.find_index('.')
    data_idx = start_idx + (data - 1) - i
    if index.nil? || index > data_idx
      is_done = true
      break
    end

    ary[index] = id
    ary[data_idx] = '.'
  end
  break if is_done
end

ary
  .delete_if { _1.is_a?(String) }
  .each.with_index
  .inject(0) { |sum, (num, idx)| sum + (num * idx) }
