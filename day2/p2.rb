#!/usr/bin/env ruby
require 'set'

input = File.readlines("p1_input.txt")

answers = []

barcodes = input.map{|barcode| barcode.chars[0..-2]}.sort
(0..(barcodes.length-1)).each do |x| 
  (0..(barcodes.length-1)).each do |y| 
    intersection = ((barcodes[x] - barcodes[y]) + (barcodes[y] - barcodes[x]))
    if intersection.length == 1
      answers << {barcodex: barcodes[x].join(""), barcodey: barcodes[y].join(""), x: x, y: y, intersection: intersection}
    end
  end
end

puts answers.length
exit
answers.each{|answer| puts "barcodex: #{answer[:barcodex]}\nbarcodey: #{answer[:barcodey]}\n----\n" }
