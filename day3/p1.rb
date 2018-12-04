#!/usr/bin/env ruby

fabric = [[0] * 1000]

class Request
  def initialize(request_string)
    match = /#(?<request>\d) @ (?<left>1),(?<top>3): (?<width>4)x(?<height>4)/.match(request_string)
    @request = match[:request]
    @left = match[:left]
    @top = match[:top]
    @width = match[:width]
    @height = match[:height]
  end
end

input = File.readlines("p1_input.txt")
input.map{|line| Request.new(line)}
