# ruby_testing_snippets.rb
# RSpec and simple Ruby testing snippets for pair programming interviews.
#
# Setup:
#   gem install rspec
#
# Run:
#   rspec ruby_testing_snippets.rb
#
# Note:
# This file defines methods and then tests them in the same file for easy reference.

require "csv"
require "tempfile"
require "fileutils"

# -----------------------------------------------------------------------------
# Code under test
# -----------------------------------------------------------------------------

def totals_by_customer(orders)
  totals = Hash.new(0)

  orders.each do |order|
    totals[order[:customer_id]] += order[:total]
  end

  totals
end

def dedupe_preserving_order(values)
  seen = {}
  result = []

  values.each do |value|
    next if seen[value]

    seen[value] = true
    result << value
  end

  result
end

def merge_intervals(intervals)
  return [] if intervals.empty?

  sorted = intervals.sort_by { |start_time, _end_time| start_time }
  merged = [sorted.first.dup]

  sorted[1..].each do |current|
    last = merged[-1]

    if current[0] <= last[1]
      last[1] = [last[1], current[1]].max
    else
      merged << current.dup
    end
  end

  merged
end

def parse_positive_integer(value)
  number = Integer(value)
  raise ArgumentError, "number must be positive" if number <= 0

  number
end

def count_csv_rows(path)
  count = 0

  CSV.foreach(path, headers: true) do |_row|
    count += 1
  end

  count
end

# -----------------------------------------------------------------------------
# RSpec examples
# -----------------------------------------------------------------------------

RSpec.describe "Ruby testing snippets" do
  describe "#totals_by_customer" do
    it "sums totals by customer" do
      orders = [
        { customer_id: 1, total: 25 },
        { customer_id: 2, total: 10 },
        { customer_id: 1, total: 15 }
      ]

      expect(totals_by_customer(orders)).to eq({ 1 => 40, 2 => 10 })
    end

    it "returns an empty hash for no orders" do
      expect(totals_by_customer([])).to eq({})
    end
  end

  describe "#dedupe_preserving_order" do
    it "keeps the first occurrence of each value" do
      expect(dedupe_preserving_order([3, 1, 3, 2, 1])).to eq([3, 1, 2])
    end

    it "handles an empty array" do
      expect(dedupe_preserving_order([])).to eq([])
    end

    it "keeps nil as a valid value" do
      expect(dedupe_preserving_order([nil, nil, 1])).to eq([nil, 1])
    end
  end

  describe "#merge_intervals" do
    it "merges overlapping intervals" do
      expect(merge_intervals([[9, 11], [10, 12], [13, 15]])).to eq([[9, 12], [13, 15]])
    end

    it "merges touching intervals" do
      expect(merge_intervals([[9, 10], [10, 11]])).to eq([[9, 11]])
    end

    it "handles unsorted intervals" do
      expect(merge_intervals([[13, 15], [9, 11], [10, 12]])).to eq([[9, 12], [13, 15]])
    end

    it "handles an empty list" do
      expect(merge_intervals([])).to eq([])
    end
  end

  describe "#parse_positive_integer" do
    it "parses a valid positive integer" do
      expect(parse_positive_integer("42")).to eq(42)
    end

    it "raises for zero" do
      expect { parse_positive_integer("0") }.to raise_error(ArgumentError, "number must be positive")
    end

    it "raises for non-numeric input" do
      expect { parse_positive_integer("abc") }.to raise_error(ArgumentError)
    end
  end

  describe "#count_csv_rows" do
    it "counts CSV data rows using a temp file" do
      Tempfile.create(["orders", ".csv"]) do |file|
        file.write("id,total\n1,25.50\n2,13.00\n")
        file.flush

        expect(count_csv_rows(file.path)).to eq(2)
      end
    end
  end
end

# -----------------------------------------------------------------------------
# Common RSpec matchers
# -----------------------------------------------------------------------------
#
# expect(value).to eq(expected)
# expect(value).not_to eq(unexpected)
# expect(array).to include(item)
# expect(hash).to include(key: value)
# expect(value).to be_nil
# expect(value).to be_empty
# expect(number).to be > 10
# expect { risky_call }.to raise_error(ArgumentError)
#
# -----------------------------------------------------------------------------
# Simple no-gem test helpers
# -----------------------------------------------------------------------------

def assert_equal(expected, actual)
  return if expected == actual

  raise "Expected #{expected.inspect}, got #{actual.inspect}"
end

def assert(condition, message = "Assertion failed")
  raise message unless condition
end

if __FILE__ == $PROGRAM_NAME && !defined?(RSpec)
  assert_equal([3, 1, 2], dedupe_preserving_order([3, 1, 3, 2, 1]))
  assert_equal([[9, 12]], merge_intervals([[9, 11], [10, 12]]))
  assert(totals_by_customer([{ customer_id: 1, total: 5 }])[1] == 5)

  puts "Simple assertions passed."
end

# -----------------------------------------------------------------------------
# Interview testing checklist
# -----------------------------------------------------------------------------
#
# Always try:
# - happy path
# - empty input
# - single item
# - duplicates
# - nil values if allowed
# - invalid values if relevant
# - unsorted input
# - boundary values
# - tie behavior
# - large input / performance assumption
#
# Useful phrase:
# "Before I keep coding, I want to test the smallest happy path and one edge case."
