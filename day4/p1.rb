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
      @guard_id ||= guard_check[:id].to_i
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
  attr_reader :guard, :start, :end, :duration, :day

  def initialize(guard_id, log_start, log_end, day)
    @day = day
    @guard = guard_id
    @start = log_start
    @end = log_end - 1
    @duration = @end - @start
  end

  def to_s
    "guard #{@guard} on #{@day} asleep #{@start}-#{@end} total #{@duration}"
  end
end


input = ARGV[0]
log_lines = File.readlines(input).map{|line| LogLine.new(line)}.sort
log log_lines

guard_sleep_total = Hash.new(0)
guard_shifts = []
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
      shift = Shift.new(current_guard, start, finish, day)
      guard_sleep_total[shift.guard] += shift.duration
      guard_shifts << shift
      line_offset += 2
    end
  end
end

sleepiest_guard = guard_sleep_total.sort{|a,b| a[1] <=> b[1]}.last[0]
puts "Sleepiest guard: guard ##{sleepiest_guard}"

sleep_times = Hash.new{|hash,key| hash[key] = Hash.new(0)}
guard_shifts.group_by(&:day).each_pair do |day, shifts|
  shifts.each do |shift|
    (shift.start..shift.end).each{|n| sleep_times[shift.guard][n] += 1}
  end
end

sleepiest_min = sleep_times[sleepiest_guard].sort{|a,b| b[1] <=> a[1]}.first.first
puts "Sleepiest minute: minute #{sleepiest_min}"
puts "Answer: #{sleepiest_guard} * #{sleepiest_min} = #{sleepiest_guard*sleepiest_min}"
