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
  def initialize
    @count = 0
    @requests = Array.new
  end

  def to_s
    "Cell: #{@count} equests\n=============\n#{@requests.map{|req| req.to_s}.join("\n")}"
  end
end

# Parse the input file into requests
input = File.readlines("p1_input.txt")
requests = input.map{|line| Request.new(line)}

# We want to make a NxN matrix.  This figures out the N we need by 
# taking the largest diminsion in the data.
max_rows = requests.map{|req| req.top + req.height}.max
max_cols = requests.map{|req| req.left + req.width}.max
array_size = [max_rows, max_cols].max + 1

# Create the matrix at the correct size and set the default value to a
# new cell which lets us count and store requests for each cell.
fabric_cells = Array.new(array_size){ Array.new(array_size){Cell.new} }

# Loop through each request and mark the fabric where each request
# would take up space by adding one for each request of a given square
# inch.  Also, store the requests for each square inch and the requests
# if they overlap with another request.
requests.each do |request|
  request.height_range.each do |row|
    request.width_range.each do |col|
      fabric_cells[row][col].requests << request
      fabric_cells[row][col].count += 1
      if fabric_cells[row][col].count > 1
        fabric_cells[row][col].requests.each{|req| req.overlapped = true}
      end
    end
  end
end

# For the answer, we no longer care about diminsions so flatten the
# array.  Select only cells that have a count of because the area of
# fabric that has no overlap will have a count of 1 for the entire
# region.  Once we have only cells with only a single request, select
# the cell that doesn't have any overlap.
puts fabric_cells
  .flatten
  .select{|cell| cell.count == 1}
  .select{|cell| !cell.requests.first.overlapped}
  .first
