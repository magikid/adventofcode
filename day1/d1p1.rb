#!/usr/bin/env ruby

lines = File.readlines("d1p1_input.txt")
puts lines.map(&:to_i).sum
