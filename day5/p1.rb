#!/usr/bin/env ruby

def first_pair(string)
  string.index(/([[:alpha:]])(?!\1)(?i)\1/)
end

input = ARGV[0]
lines = File.readlines(input)

polymer = lines.first
final_polymer = ""

while true do
  pair_index = first_pair polymer
  if pair_index.nil?
    break
  end

  polymer = polymer[0..pair_index-1] + polymer[pair_index+2..-1]
end

puts "Remaining units: #{polymer.length-1}"
