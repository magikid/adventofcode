#!/usr/bin/env ruby
require 'set'

input = File.readlines("p1_input.txt")

# Stolen from wikibooks:
# https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#Ruby
def levenshtein(first:, second:)
  matrix = [(0..first.length).to_a]
  (1..second.length).each do |j|
    matrix << [j] + [0] * (first.length)
  end

  (1..second.length).each do |i|
    (1..first.length).each do |j|
      if first[j-1] == second[i-1]
        matrix[i][j] = matrix[i-1][j-1]
      else
        matrix[i][j] = [
          matrix[i-1][j],
          matrix[i][j-1],
          matrix[i-1][j-1],
        ].min + 1
      end
    end
  end
  return matrix.last.last
end

answer_found = false
answers = []

barcodes = input.map{|barcode| barcode.chars[0..-2].join("")}
(0..(barcodes.length-1)).each do |x| 
  (0..(barcodes.length-1)).each do |y| 
    intersection = levenshtein(first: barcodes[x], second: barcodes[y])
    if intersection == 1
      answers << {barcodex: barcodes[x], barcodey: barcodes[y], x: x, y: y, intersection: intersection}
      answer_found = true
      break
    end
  end
  break if answer_found
end

answers.each{|answer| puts "barcodex: #{answer[:barcodex]}\nbarcodey: #{answer[:barcodey]}\n----\n" }
