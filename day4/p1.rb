#!/usr/bin/env ruby
require 'date'

class LogLine
  include Comparable
  attr_reader :date, :log

  LOG_REGEX = /\[(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minute>\d+)\] (?<log>.*)/

  def initialize(line)
    matches = LOG_REGEX.match(line)
    @date = DateTime.new(matches[:year].to_i, matches[:month].to_i, matches[:day].to_i, matches[:hour].to_i, matches[:minute].to_i)
    @log = matches[:log]
  end

  def pretty_date
    @date.strftime("%F %R")
  end

  def to_s
    "[#{pretty_date}] #{@log}"
  end

  def <=>(another)
    @date <=> another.date
  end
end


input = ARGV[0]
log_lines = File.readlines(input).map{|line| LogLine.new(line)}.sort
