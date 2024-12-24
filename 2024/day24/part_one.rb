# frozen_string_literal: true

BOOL = { '0' => false, '1' => true }.freeze

def perform(w1, gate, w2, wire)
  perform(*@operations[w1], w1) if @wires[w1].nil?
  perform(*@operations[w2], w2) if @wires[w2].nil?

  @wires[wire] = case gate
                 when 'AND'
                   result = BOOL[@wires[w1]] && BOOL[@wires[w2]]
                   BOOL.key(result)
                 when 'OR'
                   result = BOOL[@wires[w1]] || BOOL[@wires[w2]]
                   BOOL.key(result)
                 when 'XOR'
                   @wires[w1] == @wires[w2] ? '0' : '1'
                 end
end

wires, operations = File.read('input.txt').split("\n\n")
@operations = operations.gsub(/\w+/).each_slice(4).each_with_object({}) { _2[_1.last] = _1[0..-2] }
@wires = wires.gsub(/\w+/).each_slice(2).to_a.to_h

@operations.each { |w, operation| perform(*operation, w) }
binary = @wires.to_a.sort_by(&:first).map { |(wire, value)| wire.start_with?('z') ? value : nil }.reverse.join
puts binary.to_i(2)
