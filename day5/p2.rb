#!/usr/bin/env ruby

def first_pair(string)
  string.index(/([[:alpha:]])(?!\1)(?i)\1/)
end

input = ARGV[0]
lines = File.readlines(input)

def check_polymer polymer
  count = 0
  while true do
    pair_index = first_pair polymer
    if pair_index.nil?
      break
    end

    polymer = polymer[0..pair_index-1] + polymer[pair_index+2..-1]
    count += 1
    break if count > 100000
  end

  return polymer
end

polymer = lines.first.chars.compact.join("")
unit_types = polymer.downcase.chars.uniq.sort[1..-1]
results = {}
unit_types.each do |unit_type|
  new_polymer = check_polymer(polymer.dup.delete(unit_type.downcase).delete(unit_type.upcase))
  results[unit_type.to_sym] = {size: new_polymer.length - 1}
  puts "polymer: #{unit_type}, length: #{new_polymer.length - 1}"
end

shortest_polymer = results.sort{|a,b| a[:size] <=> b[:size]}
puts "Shortest polymer: #{shortest_polymer.first}"
puts shortest_polymer
