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

# puts file_blocks.join

storage.reverse_each do |id, (data_size, _, start_idx)|
  found_block = storage.find { |_, (_, tfree, _)| tfree >= data_size }
  next unless found_block

  tid, (tdata_size, tfree, tstart_idx) = found_block

  data_size.times do |i|
    data_idx = start_idx + (data_size - 1) - i
    target_idx = tstart_idx + tdata_size + i

    file_blocks[target_idx] = id
    file_blocks[data_idx] = '.'
  end

  # update storage data
  storage[id] = [0, 0, start_idx]
  storage[tid] = [tdata_size + data_size, tfree - data_size, tstart_idx]
  # puts file_blocks.join
end

file_blocks
  .each.with_index
  .inject(0) { |sum, (num, idx)| num.is_a?(String) ? sum : sum + (num * idx) }
