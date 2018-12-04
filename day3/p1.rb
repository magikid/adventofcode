#!/usr/bin/env ruby

class Request
  attr_reader :left, :top, :width, :height
  def initialize(request_string)
    match = /#(?<request>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/.match(request_string)
    @request = match[:request]
    @left = match[:left].to_i
    @top = match[:top].to_i
    @width = match[:width].to_i
    @height = match[:height].to_i
  end

  def height_range
    (@top..(@top+@height-1))
  end

  def width_range
    (@left..(@left+@width-1))
  end

  def to_s
    "##{@request} @ #{@left},#{@top}: #{@width}x#{@height}"
  end
end

def fabric_print(fabric)
  output = ""
  fabric.each do |row|
    row.each do |col|
      output += "#{col} "
    end
    output += "\n"
  end
  print output
end

input = File.readlines("p1_input.txt")
#input = File.readlines("p1_test.txt")
requests = input.map{|line| Request.new(line)}
max_rows = requests.map{|req| req.top + req.height}.max
max_cols = requests.map{|req| req.left + req.width}.max
array_size = [max_rows, max_cols].max + 1
fabric = Array.new(array_size){ Array.new(array_size, 0) }
requests.each do |request|
  request.height_range.each do |row|
    request.width_range.each do |col|
      fabric[row][col] += 1
    end
  end
end

puts fabric.flatten.count{|x| x > 1}
