# ruby_time_date_snippets.rb
# Ruby snippets for Time, Date, DateTime, ranges, and time-window problems.

require "date"
require "time"

# Current time and date.
Time.now
Time.now.utc
Date.today

# Parse dates and times.
date = Date.parse("2026-06-24")
time = Time.parse("2026-06-24 14:30:00 -0400")

# Format dates and times.
time.strftime("%Y-%m-%d")
time.strftime("%Y-%m-%d %H:%M:%S")
time.strftime("%A, %B %-d, %Y")

# Date arithmetic.
today = Date.new(2026, 6, 24)
tomorrow = today + 1
last_week = today - 7
next_month = today.next_month

# Time arithmetic.
now = Time.now
one_minute_later = now + 60
one_hour_later = now + 60 * 60
one_day_later = now + 24 * 60 * 60

# Beginning and end of day without Rails.
def beginning_of_day(date)
  Time.new(date.year, date.month, date.day, 0, 0, 0)
end

def end_of_day(date)
  Time.new(date.year, date.month, date.day, 23, 59, 59)
end

# Date ranges.
def dates_between(start_date, end_date)
  (start_date..end_date).to_a
end

# Check whether a timestamp is inside a window.
def within_window?(timestamp, start_time, end_time)
  timestamp >= start_time && timestamp <= end_time
end

# Sort records by timestamp.
def sort_by_created_at(records)
  records.sort_by { |record| record[:created_at] }
end

# Group records by date.
def group_by_date(records)
  records.group_by { |record| record[:created_at].to_date }
end

# Totals by date.
def totals_by_date(records)
  records.each_with_object(Hash.new(0.0)) do |record, totals|
    totals[record[:created_at].to_date] += record[:total]
  end
end

# Duration calculations.
def duration_minutes(started_at, finished_at)
  (finished_at - started_at) / 60.0
end

# ISO 8601.
Time.now.utc.iso8601
Time.parse("2026-06-24T14:30:00Z")

# Merge time intervals.
def merge_time_intervals(intervals)
  return [] if intervals.empty?
  sorted = intervals.sort_by { |interval| interval[:start] }
  merged = [sorted.first.dup]

  sorted[1..].each do |current|
    last = merged[-1]
    if current[:start] <= last[:end]
      last[:end] = [last[:end], current[:end]].max
    else
      merged << current.dup
    end
  end

  merged
end

# Rails equivalents:
#   Time.current
#   Date.current
#   Time.zone.parse("2026-06-24 09:00")
#   1.day.from_now
#   order.created_at.in_time_zone("America/Detroit")
#
# Interview phrase:
# "For a real app, I would store timestamps in UTC and be explicit about timezone behavior."
