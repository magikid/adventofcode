#!/usr/bin/env ruby

LOWER_TO_UPPER_REGEX = /([[:lower:]])(?!\1)(?i)\1/
UPPER_TO_LOWER_REGEX = /([[:upper:]])(?!\1)(?i)\1/

def is_upper char
  char == char.upcase
end

def is_lower char
  char == char.downcase
end

def reacting_pair(first_letter, second_letter)
  return false if first_letter.nil? or second_letter.nil? or first_letter.downcase != second_letter.downcase
  return true if is_upper first_letter and is_lower second_letter
  return true if is_lower first_letter and is_upper second_letter
end

def first_pair(string)
  string.index(/([[:alpha:]])(?!\1)(?i)\1/)
end

input = ARGV[0]
lines = File.readlines(input)

polymer = lines.first
final_polymer = ""

working = true
while working do
  pair_index = first_pair polymer
  if pair_index.nil?
    working = false
    break
  end

  polymer = polymer[0..pair_index-1] + polymer[pair_index+2..-1]
end

puts "Remaining units: #{polymer.length-1}"
puts polymer
