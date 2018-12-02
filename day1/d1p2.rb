#!/usr/bin/env ruby

require 'set'

lines = File.readlines("d1p1_input.txt").map(&:to_i)
#lines = File.readlines("d1p2_test2.txt")

def find_duplicate(arr)
  arr.select{|elem| arr.count(elem) > 1}.uniq.length > 0
end

counter = {}
freq = 0
lines.cycle do |n|
  freq += n
  if counter[freq] == 1
    puts "FOUND ANSWER: #{freq}"
    exit
  end
  counter[freq] = 1
end
