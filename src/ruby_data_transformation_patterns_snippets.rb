# frozen_string_literal: true

require "set"

# 1. Order grouping
# Given orders with customer_id and total, return totals by customer.
# Time: O(n)
# Space: O(k), where k is number of unique customers.
def totals_by_customer(orders)
  return {} if orders.nil? || orders.empty?

  totals = Hash.new(0)

  orders.each do |order|
    next if order[:customer_id].nil?

    totals[order[:customer_id]] += order[:total].to_f
  end

  totals
end

# Example:
# orders = [
#   { customer_id: 1, total: 25 },
#   { customer_id: 2, total: 10 },
#   { customer_id: 1, total: 15 }
# ]
# p totals_by_customer(orders)
# => {1=>40.0, 2=>10.0}


# 2A. Inventory availability - aggregate version
# Determines whether total available stock is enough to cover total purchases.
# Time: O(n + m)
# Space: O(1) for one SKU.
def can_fulfill?(stock_events, purchase_events, sku)
  available = 0
  required = 0

  stock_events.each do |event|
    available += event[:quantity] if event[:sku] == sku
  end

  purchase_events.each do |event|
    required += event[:quantity] if event[:sku] == sku
  end

  required <= available
end

# Example:
# stock_events = [{ sku: "A", quantity: 10 }]
# purchase_events = [{ sku: "A", quantity: 3 }, { sku: "A", quantity: 4 }]
# p can_fulfill?(stock_events, purchase_events, "A")
# => true


# 2B. Inventory availability - time-ordered version
# Determines whether inventory ever goes negative as events occur over time.
# Time: O(n log n) because of sorting
# Space: O(n) for filtered events.
def can_fulfill_over_time?(events, sku)
  inventory = 0

  relevant_events = events
                    .select { |event| event[:sku] == sku }
                    .sort_by { |event| event[:time] }

  relevant_events.each do |event|
    case event[:type]
    when :stock
      inventory += event[:quantity]
    when :purchase
      inventory -= event[:quantity]
      return false if inventory.negative?
    else
      raise ArgumentError, "Unknown inventory event type: #{event[:type].inspect}"
    end
  end

  true
end

# Example:
# events = [
#   { type: :purchase, sku: "A", quantity: 5, time: 1 },
#   { type: :stock, sku: "A", quantity: 10, time: 2 }
# ]
# p can_fulfill_over_time?(events, "A")
# => false


# 3. Deduplicate while preserving order
# Return unique items in the order they first appeared.
# Time: O(n)
# Space: O(n)
def dedupe_preserving_order(items)
  return [] if items.nil? || items.empty?

  seen = Set.new
  result = []

  items.each do |item|
    next if seen.include?(item)

    seen.add(item)
    result << item
  end

  result
end

# Example:
# p dedupe_preserving_order([3, 1, 3, 2, 1])
# => [3, 1, 2]


# 4. Most frequent item
# Finds the most frequent item, returning the first item to reach the max count.
# Time: O(n)
# Space: O(k), where k is number of unique items.
def most_frequent_item(items)
  return nil if items.nil? || items.empty?

  counts = Hash.new(0)
  best_item = nil
  best_count = 0

  items.each do |item|
    counts[item] += 1

    if counts[item] > best_count
      best_item = item
      best_count = counts[item]
    end
  end

  best_item
end

# Optional helper if the prompt asks for both item and count.
def most_frequent_item_with_count(items)
  return nil if items.nil? || items.empty?

  counts = Hash.new(0)
  best_item = nil
  best_count = 0

  items.each do |item|
    counts[item] += 1

    if counts[item] > best_count
      best_item = item
      best_count = counts[item]
    end
  end

  { item: best_item, count: best_count }
end

# Example:
# p most_frequent_item(["hat", "shirt", "hat", "mug", "hat", "mug"])
# => "hat"


# 5A. Merge time intervals - array version
# Merges overlapping intervals represented as [start, finish].
# This version treats touching intervals as mergeable: [9,10] + [10,11] => [9,11].
# Time: O(n log n) because of sorting
# Space: O(n)
def merge_intervals(intervals)
  return [] if intervals.nil? || intervals.empty?

  sorted = intervals.sort_by { |start_time, _finish_time| start_time }
  merged = [sorted.first.dup]

  sorted[1..].each do |current|
    last = merged[-1]

    current_start = current[0]
    current_end = current[1]
    last_end = last[1]

    if current_start <= last_end
      last[1] = [last_end, current_end].max
    else
      merged << current.dup
    end
  end

  merged
end

# Example:
# p merge_intervals([[9, 11], [10, 12], [13, 15]])
# => [[9, 12], [13, 15]]


# 5B. Merge time intervals - hash version
# Same idea, but for intervals represented as { start: ..., end: ... }.
def merge_intervals_by_hash(intervals)
  return [] if intervals.nil? || intervals.empty?

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

# Example:
# p merge_intervals_by_hash([
#   { start: 9, end: 11 },
#   { start: 10, end: 12 },
#   { start: 13, end: 15 }
# ])
# => [{:start=>9, :end=>12}, {:start=>13, :end=>15}]


# 6. Dependency ordering
# Given tasks and dependency pairs [before, after], return a valid build order.
# Returns nil if there is a cycle.
# Time: O(V + E)
# Space: O(V + E)
def dependency_order(tasks, dependencies)
  graph = Hash.new { |h, k| h[k] = [] }
  indegree = Hash.new(0)

  tasks.each { |task| indegree[task] = 0 }

  dependencies.each do |before, after|
    graph[before] << after
    indegree[after] += 1
    indegree[before] ||= 0
  end

  queue = indegree.select { |_task, count| count.zero? }.map(&:first)
  index = 0
  order = []

  while index < queue.length
    task = queue[index]
    index += 1

    order << task

    graph[task].each do |neighbor|
      indegree[neighbor] -= 1
      queue << neighbor if indegree[neighbor].zero?
    end
  end

  order.length == indegree.length ? order : nil
end

# Example:
# p dependency_order(
#   ["models", "controllers", "views"],
#   [["models", "controllers"], ["controllers", "views"]]
# )
# => ["models", "controllers", "views"]
#
# p dependency_order(["a", "b"], [["a", "b"], ["b", "a"]])
# => nil


# 7A. Nested collection flatten/filter - recursive version
# Traverses nested categories and returns active products.
# Time: O(c + p), categories plus products
# Space: O(d), where d is recursion depth.
def active_products(category)
  result = []
  collect_active_products(category, result)
  result
end

def collect_active_products(category, result)
  products = category[:products] || []
  subcategories = category[:categories] || []

  products.each do |product|
    result << product if product[:active]
  end

  subcategories.each do |subcategory|
    collect_active_products(subcategory, result)
  end
end

# 7B. Nested collection flatten/filter - include category path
# Useful extension when the interviewer asks for more context in the output.
def active_products_with_path(category)
  result = []
  collect_with_path(category, [], result)
  result
end

def collect_with_path(category, path, result)
  current_path = path + [category[:name]]

  (category[:products] || []).each do |product|
    result << product.merge(category_path: current_path) if product[:active]
  end

  (category[:categories] || []).each do |subcategory|
    collect_with_path(subcategory, current_path, result)
  end
end

# 7C. Nested collection flatten/filter - iterative stack version
# Use this if maximum nesting depth could be large.
def active_products_iterative(category)
  result = []
  stack = [category]

  until stack.empty?
    current = stack.pop

    (current[:products] || []).each do |product|
      result << product if product[:active]
    end

    # reverse_each preserves left-to-right traversal order when using a stack.
    (current[:categories] || []).reverse_each do |subcategory|
      stack << subcategory
    end
  end

  result
end

# Example:
# catalog = {
#   name: "root",
#   products: [],
#   categories: [
#     {
#       name: "shirts",
#       products: [
#         { name: "T-shirt", active: true },
#         { name: "Old shirt", active: false }
#       ],
#       categories: []
#     },
#     {
#       name: "hats",
#       products: [{ name: "Cap", active: true }],
#       categories: []
#     }
#   ]
# }
# p active_products(catalog)
# => [{:name=>"T-shirt", :active=>true}, {:name=>"Cap", :active=>true}]


# 8A. Sliding window - longest substring with at most k distinct characters
# Returns the actual substring.
# Time: O(n)
# Space: O(k), for characters in the current window.
def longest_substring_at_most_k_distinct(s, k)
  return "" if s.nil? || s.empty? || k <= 0

  counts = Hash.new(0)
  left = 0
  best_start = 0
  best_length = 0
  chars = s.chars

  chars.each_with_index do |char, right|
    counts[char] += 1

    while counts.length > k
      left_char = chars[left]
      counts[left_char] -= 1
      counts.delete(left_char) if counts[left_char].zero?
      left += 1
    end

    current_length = right - left + 1

    if current_length > best_length
      best_start = left
      best_length = current_length
    end
  end

  chars[best_start, best_length].join
end

# Example:
# p longest_substring_at_most_k_distinct("eceba", 2)
# => "ece"


# 8B. Sliding window - longest subarray with sum at most target
# Important: this version assumes all numbers are non-negative.
# Time: O(n)
# Space: O(1)
def longest_subarray_sum_at_most(nums, target)
  return 0 if nums.nil? || nums.empty?

  left = 0
  current_sum = 0
  best_length = 0

  nums.each_with_index do |num, right|
    current_sum += num

    while current_sum > target && left <= right
      current_sum -= nums[left]
      left += 1
    end

    best_length = [best_length, right - left + 1].max
  end

  best_length
end

# Example:
# p longest_subarray_sum_at_most([2, 1, 3, 2, 1, 1], 5)
# => 3, for [2, 1, 1] depending on position; longest valid length is 3
