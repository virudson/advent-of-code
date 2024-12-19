# frozen_string_literal: true

# colors = %w[w u b r g]
patterns, designs = File.read('input.txt').split("\n\n")
designs = designs.split("\n")
patterns = patterns.split(', ')

def valid_design?(design, patterns)
  return true if design.empty?

  matched_patterns = patterns.select { |pattern| design.start_with?(pattern) }
  matched_patterns.any? { |pattern| valid_design?(design[pattern.size..], patterns) }
end

possible_designs = designs.select { |design| valid_design?(design, patterns) }
puts possible_designs.size
