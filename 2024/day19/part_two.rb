# frozen_string_literal: true

# colors = %w[w u b r g]
patterns, designs = File.read('input.txt').split("\n\n")
designs = designs.split("\n")
patterns = patterns.split(', ')

def possible_design_count(design, patterns, counter = {})
  return 1 if design.empty?
  return counter[design] if counter[design]

  matched_patterns = patterns.select { |pattern| design.start_with?(pattern) }
  counter[design] = matched_patterns.sum do |pattern|
    possible_design_count(design[pattern.size..], patterns, counter)
  end
end

possible_designs = designs.sum { |design| possible_design_count(design, patterns) }
puts possible_designs
