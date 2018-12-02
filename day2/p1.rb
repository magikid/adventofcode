#!/usr/bin/env ruby

input = File.readlines("p1_input.txt")

twos_counter = 0
threes_counter = 0

def counts(k,v,h)
  if h[v.length] and k
    h[v.length] += k
  else
    h[v.length] = k
  end
end

input.each do |barcode|
  checksum = barcode
    .each_char
    .group_by(&:itself)
    .keep_if{|k, v| v.length == 2 or v.length == 3}
    .each_with_object({}){ |(k,v), h| counts(k,v,h)}
  if checksum[2]
    twos_counter += 1
  end
  if checksum[3]
    threes_counter += 1
  end
end

puts "Twos counter #{twos_counter}"
puts "Threes counter #{threes_counter}"
puts "Checksum: #{twos_counter * threes_counter}"
