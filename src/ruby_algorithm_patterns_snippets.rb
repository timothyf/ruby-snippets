# ruby_algorithm_patterns_snippets.rb
# Reusable Ruby algorithm pattern snippets.
#
# Run:
#   ruby ruby_algorithm_patterns_snippets.rb

require "set"

# -----------------------------------------------------------------------------
# 1. Frequency hash
# -----------------------------------------------------------------------------

def frequencies(values)
  counts = Hash.new(0)
  values.each { |value| counts[value] += 1 }
  counts
end

puts frequencies(["hat", "shirt", "hat"]).inspect

# -----------------------------------------------------------------------------
# 2. Most frequent item
# -----------------------------------------------------------------------------

def most_frequent(values)
  return nil if values.empty?

  counts = Hash.new(0)
  best_value = nil
  best_count = 0

  values.each do |value|
    counts[value] += 1

    if counts[value] > best_count
      best_value = value
      best_count = counts[value]
    end
  end

  { value: best_value, count: best_count }
end

puts most_frequent(["hat", "shirt", "hat", "mug"]).inspect

# -----------------------------------------------------------------------------
# 3. Two pointers: pair sum in sorted array
# -----------------------------------------------------------------------------

def pair_sum?(numbers, target)
  left = 0
  right = numbers.length - 1

  while left < right
    sum = numbers[left] + numbers[right]

    if sum == target
      return true
    elsif sum < target
      left += 1
    else
      right -= 1
    end
  end

  false
end

puts pair_sum?([1, 2, 4, 7, 11], 9)

# -----------------------------------------------------------------------------
# 4. Sliding window: longest substring with at most k distinct chars
# -----------------------------------------------------------------------------

def longest_substring_at_most_k_distinct(text, k)
  return "" if text.empty? || k <= 0

  chars = text.chars
  counts = Hash.new(0)
  left = 0
  best_start = 0
  best_length = 0

  chars.each_with_index do |char, right|
    counts[char] += 1

    while counts.length > k
      left_char = chars[left]
      counts[left_char] -= 1
      counts.delete(left_char) if counts[left_char] == 0
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

puts longest_substring_at_most_k_distinct("eceba", 2)

# -----------------------------------------------------------------------------
# 5. Sliding window: longest subarray sum <= target
# Works when all numbers are non-negative.
# -----------------------------------------------------------------------------

def longest_subarray_sum_at_most(numbers, target)
  left = 0
  current_sum = 0
  best_length = 0

  numbers.each_with_index do |number, right|
    current_sum += number

    while current_sum > target && left <= right
      current_sum -= numbers[left]
      left += 1
    end

    best_length = [best_length, right - left + 1].max
  end

  best_length
end

puts longest_subarray_sum_at_most([1, 2, 1, 1, 3], 4)

# -----------------------------------------------------------------------------
# 6. Binary search
# -----------------------------------------------------------------------------

def binary_search(numbers, target)
  left = 0
  right = numbers.length - 1

  while left <= right
    mid = left + (right - left) / 2

    if numbers[mid] == target
      return mid
    elsif numbers[mid] < target
      left = mid + 1
    else
      right = mid - 1
    end
  end

  nil
end

puts binary_search([1, 3, 5, 7, 9], 7).inspect

# -----------------------------------------------------------------------------
# 7. Merge intervals
# -----------------------------------------------------------------------------

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

puts merge_intervals([[9, 11], [10, 12], [13, 15]]).inspect

# -----------------------------------------------------------------------------
# 8. BFS on graph
# -----------------------------------------------------------------------------

def bfs(graph, start)
  visited = Set[start]
  queue = [start]
  index = 0
  order = []

  while index < queue.length
    node = queue[index]
    index += 1
    order << node

    graph.fetch(node, []).each do |neighbor|
      next if visited.include?(neighbor)

      visited.add(neighbor)
      queue << neighbor
    end
  end

  order
end

graph = {
  "a" => ["b", "c"],
  "b" => ["d"],
  "c" => [],
  "d" => []
}

puts bfs(graph, "a").inspect

# -----------------------------------------------------------------------------
# 9. DFS recursive
# -----------------------------------------------------------------------------

def dfs_recursive(graph, node, visited = Set.new, order = [])
  return order if visited.include?(node)

  visited.add(node)
  order << node

  graph.fetch(node, []).each do |neighbor|
    dfs_recursive(graph, neighbor, visited, order)
  end

  order
end

puts dfs_recursive(graph, "a").inspect

# -----------------------------------------------------------------------------
# 10. DFS iterative
# -----------------------------------------------------------------------------

def dfs_iterative(graph, start)
  visited = Set.new
  stack = [start]
  order = []

  until stack.empty?
    node = stack.pop
    next if visited.include?(node)

    visited.add(node)
    order << node

    graph.fetch(node, []).reverse_each do |neighbor|
      stack << neighbor
    end
  end

  order
end

puts dfs_iterative(graph, "a").inspect

# -----------------------------------------------------------------------------
# 11. Topological sort / dependency ordering
# dependencies are [before, after]
# -----------------------------------------------------------------------------

def dependency_order(tasks, dependencies)
  graph = Hash.new { |hash, key| hash[key] = [] }
  indegree = Hash.new(0)

  tasks.each { |task| indegree[task] = 0 }

  dependencies.each do |before, after|
    graph[before] << after
    indegree[after] += 1
    indegree[before] ||= 0
  end

  queue = indegree.select { |_task, count| count == 0 }.map(&:first)
  index = 0
  order = []

  while index < queue.length
    task = queue[index]
    index += 1
    order << task

    graph[task].each do |neighbor|
      indegree[neighbor] -= 1
      queue << neighbor if indegree[neighbor] == 0
    end
  end

  order.length == indegree.length ? order : nil
end

puts dependency_order(
  ["models", "controllers", "views"],
  [["models", "controllers"], ["controllers", "views"]]
).inspect

puts dependency_order(["a", "b"], [["a", "b"], ["b", "a"]]).inspect

# -----------------------------------------------------------------------------
# 12. Backtracking: combinations
# -----------------------------------------------------------------------------

def combinations(values, size)
  result = []
  current = []

  backtrack = lambda do |start|
    if current.length == size
      result << current.dup
      return
    end

    (start...values.length).each do |index|
      current << values[index]
      backtrack.call(index + 1)
      current.pop
    end
  end

  backtrack.call(0)
  result
end

puts combinations([1, 2, 3], 2).inspect

# -----------------------------------------------------------------------------
# 13. Memoization: Fibonacci
# -----------------------------------------------------------------------------

def fibonacci(n, memo = {})
  return n if n <= 1
  return memo[n] if memo.key?(n)

  memo[n] = fibonacci(n - 1, memo) + fibonacci(n - 2, memo)
end

puts fibonacci(10)

# -----------------------------------------------------------------------------
# Interview pattern reminders
# -----------------------------------------------------------------------------
#
# Lookup / seen values       => Hash or Set
# Counts / most frequent     => Hash.new(0)
# Group records              => Hash.new { |h, k| h[k] = [] }
# Sorted input               => two pointers or binary search
# Contiguous range           => sliding window
# Overlapping ranges         => sort + merge
# Nested data                => DFS
# Shortest path / levels     => BFS
# Dependencies               => topological sort
# Repeated subproblem        => memoization / dynamic programming
# All possible choices       => backtracking
