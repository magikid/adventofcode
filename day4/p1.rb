#!/usr/bin/env ruby
require 'date'

def log msg
  puts msg if ENV.fetch("DEBUG", false)
end

class LogLine
  include Comparable
  attr_reader :date, :log, :guard_id

  LOG_REGEX = /\[(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minute>\d+)\] (?<log>.*)/
  GUARD_REGEX = /Guard #(?<id>\d+) begins shift/

  def initialize(line)
    matches = LOG_REGEX.match(line)
    @date = DateTime.new(matches[:year].to_i, matches[:month].to_i, matches[:day].to_i, matches[:hour].to_i, matches[:minute].to_i)
    @log = matches[:log]

    guard_check = GUARD_REGEX.match(@log)
    if guard_check
      @guard_id ||= guard_check[:id].to_sym
      @guard = true
    else
      @guard_id = 0
      @guard = false
    end
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

  def new_guard?
    @guard
  end
end

class LogEntry
  attr_reader :guard_id, :start, :end, :duration

  def initialize(guard_id, log_start, log_end)
    @guard_id = guard_id
    @start = log_start.date
    @end = log_end.date
    @duration = @end - @start
  end
end


input = ARGV[0]
log_lines = File.readlines(input).map{|line| LogLine.new(line)}.sort

guard_times = Hash.new()
current_line = 0
while current_line < log_lines.length
  if log_lines[current_line].new_guard?
    guard_start = current_line + 1
    guard_id = log_lines[current_line].guard_id
    log "new guard #{guard_id}"
    guard_times[guard_id] = []
    while guard_start < log_lines.length && !log_lines[guard_start].new_guard?
      log "#{log_lines[guard_start]} #{guard_start}"
      guard_times[guard_id] << log_lines[guard_start]
      guard_start += 1
    end
  end
  current_line = guard_start
  log "current_line: #{current_line}"
end

puts guard_times[:"10"][0]
