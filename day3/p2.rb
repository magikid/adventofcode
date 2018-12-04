#!/usr/bin/env ruby

class Request
  attr_reader :left, :top, :width, :height
  attr_accessor :overlapped
  def initialize(request_string)
    match = /#(?<request>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/.match(request_string)
    @request = match[:request]
    @left = match[:left].to_i
    @top = match[:top].to_i
    @width = match[:width].to_i
    @height = match[:height].to_i
    @overlapped = false
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

class Cell
  attr_accessor :count, :requests
  attr_reader :overlapped
  def initialize
    @count = 0
    @requests = Array.new
  end
  
  def to_s
    "cell #{@count} #{@requests.map{|req| req.to_s}.join("\n")}"
  end
end

input = File.readlines("p1_input.txt")
#input = File.readlines("p1_test.txt")
requests = input.map{|line| Request.new(line)}
max_rows = requests.map{|req| req.top + req.height}.max
max_cols = requests.map{|req| req.left + req.width}.max
array_size = [max_rows, max_cols].max + 1
puts "Array size: #{array_size}x#{array_size}"
fabric_cells = Array.new(array_size){ Array.new(array_size){Cell.new} }
requests.each do |request|
  request.height_range.each do |row|
    request.width_range.each do |col|
      fabric_cells[row][col].requests << request
      fabric_cells[row][col].count += 1
      if fabric_cells[row][col].requests.length > 1
        fabric_cells[row][col].requests.each{|req| req.overlapped = true}
      end
    end
  end
end

puts fabric_cells.flatten.select{|cell| cell.count == 1}.map(&:requests).select{|req| !req[0].overlapped}[0]
