# ruby_refactoring_patterns_snippets.rb
# Ruby refactoring patterns for pair programming interviews.

# Replace nested conditionals with guard clauses.
def discount_for(order)
  return 0 unless order[:paid]
  return 0 if order[:refunded]
  return 0 unless order[:total] >= 100
  10
end

# Extract method.
def eligible_for_free_shipping?(order)
  domestic_order?(order) && order[:total] >= 50 && !order[:hazardous]
end

def domestic_order?(order)
  order[:country] == "US"
end

# Replace magic strings with constants.
class OrderStatus
  PENDING = "pending"
  PAID = "paid"
  FULFILLED = "fulfilled"
  CANCELED = "canceled"
  ALL = [PENDING, PAID, FULFILLED, CANCELED].freeze
end

def paid?(order)
  order[:status] == OrderStatus::PAID
end

# Separate parsing from calculation.
def parse_order(row)
  {
    id: row.fetch("id").to_i,
    customer_id: row.fetch("customer_id").to_i,
    total: row.fetch("total").to_f
  }
end

def totals_by_customer(orders)
  orders.each_with_object(Hash.new(0.0)) do |order, totals|
    totals[order[:customer_id]] += order[:total]
  end
end

# Extract query condition.
def active_vip_customers(customers)
  customers.select { |customer| active_vip_customer?(customer) }
end

def active_vip_customer?(customer)
  customer[:active] && customer[:tags].include?("vip")
end

# Prefer returning normalized values over mutating inputs when possible.
def normalized_order(order)
  {
    id: order[:id],
    sku: order[:sku].to_s.strip.upcase,
    total: order[:total].to_f
  }
end

# Make tie-breaking explicit.
def most_frequent_first_seen(values)
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

  best_value
end

# Replace long parameter lists with keyword arguments.
def create_order(customer_id:, sku:, quantity:, total:)
  { customer_id: customer_id, sku: sku, quantity: quantity, total: total }
end

# Extract class when data and behavior belong together.
class Inventory
  def initialize(stock)
    @stock = stock.dup
  end

  def available?(sku, quantity)
    stock.fetch(sku, 0) >= quantity
  end

  def reserve(sku, quantity)
    return false unless available?(sku, quantity)
    stock[sku] -= quantity
    true
  end

  private

  attr_reader :stock
end

# Interview phrases:
# - "The logic works; now I’d clean up names to make the intent clearer."
# - "I’m separating parsing from calculation so the core logic is easier to test."
# - "I’ll avoid over-refactoring unless we have extra time."
