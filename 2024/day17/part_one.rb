# frozen_string_literal: true

def get_combo(operand)
  case operand
  when 0..3 then operand
  when 4 then @register[:a]
  when 5 then @register[:b]
  when 6 then @register[:c]
  else
    raise 'Invalid operand'
  end
end

registers, programs = File.read('input.txt').split("\n\n")
@register = %i[a b c].zip(registers.gsub(/\d+/).map(&:to_i)).to_h
programs = programs.gsub(/\d/).map(&:to_i)
pointer = 0
answer = []

loop do
  program = programs[pointer]
  operand = programs[pointer + 1]
  combo = get_combo(operand) if operand

  case program
  when 0 # adv
    @register[:a] /= 2 ** combo
    pointer += 2
  when 1 # bxl
    @register[:b] ^= operand
    pointer += 2
  when 2
    @register[:b] = combo % 8
    pointer += 2
  when 3 # jnz
    if @register[:a].zero?
      pointer += 2
    else
      pointer = operand
    end
  when 4 # bxc
    @register[:b] ^= @register[:c]
    pointer += 2
  when 5 # out
    answer << (combo % 8)
    pointer += 2
  when 6 # bdv
    @register[:b] = @register[:a] / (2 ** combo)
    pointer += 2
  when 7 # cdv
    @register[:c] = @register[:a] / (2 ** combo)
    pointer += 2
  end
  break if pointer >= programs.size
end

puts answer.join(',')
