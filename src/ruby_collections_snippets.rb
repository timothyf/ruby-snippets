# ruby_collections_snippets.rb
# Quick Ruby collection snippets for pair programming interviews.
#
# Run:
#   ruby ruby_collections_snippets.rb

require "set"

# -----------------------------------------------------------------------------
# Sample data
# -----------------------------------------------------------------------------

orders = [
  { id: 1, customer_id: 10, sku: "A100", total: 25.50, status: "paid" },
  { id: 2, customer_id: 20, sku: "B200", total: 13.00, status: "pending" },
  { id: 3, customer_id: 10, sku: "A100", total: 10.00, status: "paid" },
  { id: 4, customer_id: 30, sku: "C300", total: 99.99, status: "refunded" }
]

items = ["hat", "shirt", "hat", "mug", "shirt", "hat"]

# -----------------------------------------------------------------------------
# Arrays: map, select, reject, filter_map
# -----------------------------------------------------------------------------

names = ["Chris", "Felix", "Elizabeth", nil, "André"]

upcased_names = names.compact.map(&:upcase)
puts upcased_names.inspect

long_names = names.compact.select { |name| name.length > 5 }
puts long_names.inspect

short_or_missing = names.reject { |name| name && name.length > 5 }
puts short_or_missing.inspect

# filter_map transforms and removes nil values.
emails = [
  { name: "Chris", email: "chris@example.com" },
  { name: "Milo", email: nil }
]

valid_emails = emails.filter_map { |person| person[:email] }
puts valid_emails.inspect

# -----------------------------------------------------------------------------
# Hash defaults
# -----------------------------------------------------------------------------

counts = Hash.new(0)
items.each { |item| counts[item] += 1 }
puts counts.inspect

groups = Hash.new { |hash, key| hash[key] = [] }
orders.each { |order| groups[order[:customer_id]] << order }
puts groups.inspect

# -----------------------------------------------------------------------------
# tally
# -----------------------------------------------------------------------------

puts items.tally.inspect
puts orders.map { |order| order[:sku] }.tally.inspect

# -----------------------------------------------------------------------------
# group_by
# -----------------------------------------------------------------------------

orders_by_customer = orders.group_by { |order| order[:customer_id] }
puts orders_by_customer.inspect

orders_by_status = orders.group_by { |order| order[:status] }
puts orders_by_status.inspect

# -----------------------------------------------------------------------------
# each_with_object
# -----------------------------------------------------------------------------

totals_by_customer = orders.each_with_object(Hash.new(0)) do |order, totals|
  totals[order[:customer_id]] += order[:total]
end

puts totals_by_customer.inspect

skus_by_customer = orders.each_with_object(Hash.new { |hash, key| hash[key] = Set.new }) do |order, result|
  result[order[:customer_id]].add(order[:sku])
end

puts skus_by_customer.inspect

# -----------------------------------------------------------------------------
# transform_values / transform_keys
# -----------------------------------------------------------------------------

rounded_totals = totals_by_customer.transform_values { |total| total.round(2) }
puts rounded_totals.inspect

string_keys = rounded_totals.transform_keys(&:to_s)
puts string_keys.inspect

# -----------------------------------------------------------------------------
# Sorting
# -----------------------------------------------------------------------------

numbers = [5, 2, 9, 1, 5]
puts numbers.sort.inspect
puts numbers.sort.reverse.inspect

sorted_orders = orders.sort_by { |order| [order[:customer_id], order[:total]] }
puts sorted_orders.inspect

highest_total_first = orders.sort_by { |order| -order[:total] }
puts highest_total_first.inspect

# -----------------------------------------------------------------------------
# min_by / max_by
# -----------------------------------------------------------------------------

largest_order = orders.max_by { |order| order[:total] }
smallest_order = orders.min_by { |order| order[:total] }

puts largest_order.inspect
puts smallest_order.inspect

# -----------------------------------------------------------------------------
# any? / all? / none? / one?
# -----------------------------------------------------------------------------

puts orders.any? { |order| order[:status] == "refunded" }
puts orders.all? { |order| order[:total] > 0 }
puts orders.none? { |order| order[:total].negative? }
puts orders.one? { |order| order[:status] == "pending" }

# -----------------------------------------------------------------------------
# Sets
# -----------------------------------------------------------------------------

seen_skus = Set.new

orders.each do |order|
  if seen_skus.include?(order[:sku])
    puts "Duplicate SKU seen: #{order[:sku]}"
  else
    seen_skus.add(order[:sku])
  end
end

first = Set["A100", "B200"]
second = Set["B200", "C300"]

puts (first | second).inspect # union
puts (first & second).inspect # intersection
puts (first - second).inspect # difference

# -----------------------------------------------------------------------------
# Deduplicate while preserving order
# -----------------------------------------------------------------------------

def dedupe_preserving_order(values)
  seen = Set.new
  result = []

  values.each do |value|
    next if seen.include?(value)

    seen.add(value)
    result << value
  end

  result
end

puts dedupe_preserving_order([3, 1, 3, 2, 1]).inspect

# -----------------------------------------------------------------------------
# Nested hashes: dig and fetch
# -----------------------------------------------------------------------------

payload = {
  customer: {
    profile: {
      email: "timothy@example.com"
    }
  }
}

puts payload.dig(:customer, :profile, :email)

# fetch raises if the key is missing unless you provide a default.
puts payload.fetch(:customer).fetch(:profile).fetch(:email)
puts payload.fetch(:missing, "default value")

# -----------------------------------------------------------------------------
# Partition
# -----------------------------------------------------------------------------

paid_orders, unpaid_orders = orders.partition { |order| order[:status] == "paid" }

puts paid_orders.inspect
puts unpaid_orders.inspect

# -----------------------------------------------------------------------------
# Chunking
# -----------------------------------------------------------------------------

numbers.each_slice(2) do |pair|
  puts "Pair: #{pair.inspect}"
end

# -----------------------------------------------------------------------------
# Flatten
# -----------------------------------------------------------------------------

nested = [[1, 2], [3, [4, 5]]]

puts nested.flatten.inspect
puts nested.flatten(1).inspect

# -----------------------------------------------------------------------------
# Compact
# -----------------------------------------------------------------------------

values = [1, nil, 2, nil, 3]
puts values.compact.inspect

# -----------------------------------------------------------------------------
# Zip
# -----------------------------------------------------------------------------

names = ["Chris", "Felix", "Elizabeth"]
matches = ["Felix", "Elizabeth", "Chris"]

pairs = names.zip(matches)
puts pairs.inspect

# -----------------------------------------------------------------------------
# Reduce / inject
# -----------------------------------------------------------------------------

total = orders.reduce(0) { |sum, order| sum + order[:total] }
puts total.round(2)

# -----------------------------------------------------------------------------
# Useful interview notes
# -----------------------------------------------------------------------------
#
# Hash.new(0)                  => counting / totals
# Hash.new { |h, k| h[k] = [] } => grouping
# Set                          => uniqueness / seen checks
# group_by                     => organize records by key
# tally                        => frequency count
# sort_by                      => simple readable sorting
# each_with_object             => build a result while iterating
# dig                          => safe nested lookup
# partition                    => split into matching/non-matching groups
