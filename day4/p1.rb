#!/usr/bin/env ruby
require 'date'
require 'active_support/core_ext/time'

def log msg
  puts msg if ENV.fetch("DEBUG", false)
end

class LogLine
  include Comparable
  attr_reader :date, :log_line, :guard_id

  LOG_REGEX = /\[(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minute>\d+)\] (?<log>.*)/
  GUARD_REGEX = /Guard #(?<id>\d+) begins shift/

  def initialize(line)
    matches = LOG_REGEX.match(line)
    @log_line = matches[:log]

    guard_check = GUARD_REGEX.match(@log_line)
    if guard_check
      @guard_id ||= guard_check[:id].to_sym
      @guard = true
    else
      @guard_id = 0
      @guard = false
    end
    @date = parse_date(matches)
  end

  def parse_date(matches)
    date = Time.local(matches[:year].to_i, matches[:month].to_i, matches[:day].to_i, matches[:hour].to_i, matches[:minute].to_i)
    if date.hour == 23
      date = date.next_day.at_midnight
      log "Shifting date forward: #{date} #{@log_line}"
    end
    date
  end

  def pretty_date
    @date.strftime("%F %R")
  end

  def to_s
    "[#{pretty_date}] #{@log_line}"
  end

  def <=>(another)
    @date <=> another.date
  end

  def new_guard?
    @guard
  end
end

class Shift
  attr_reader :guard, :start, :end, :duration

  def initialize(guard_id, log_start, log_end)
    @guard = guard_id
    @start = log_start
    @end = log_end
    @duration = @end - @start
    log "guard #{@guard} asleep #{@duration} mins"
  end
end


input = ARGV[0]
log_lines = File.readlines(input).map{|line| LogLine.new(line)}.sort
log log_lines

guard_sleep_total = Hash.new(0)
days_shifts = log_lines.group_by{|line| line.date.to_date.iso8601}
days_shifts.each_pair do |day, lines|
  line_offset = 0
  log day
  while line_offset < lines.length
    if lines[line_offset].new_guard?
      current_guard = lines[line_offset].guard_id
      log "new guard: #{current_guard}"
      line_offset += 1
    else
      start = lines[line_offset].date.min
      finish = lines[line_offset+1].date.min
      shift = Shift.new(current_guard, start, finish)
      guard_sleep_total[shift.guard] += shift.duration
      line_offset += 2
    end
  end
end

sleepiest_guard = guard_sleep_total.sort{|a,b| a[1] <=> b[1]}.last[0]
puts "Sleepiest guard: guard ##{sleepiest_guard}"
