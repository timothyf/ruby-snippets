# ruby_service_object_snippets.rb
# Ruby service object snippets for organizing business logic.

# Basic service object with .call
class CustomerTotals
  def self.call(orders)
    new(orders).call
  end

  def initialize(orders)
    @orders = orders
  end

  def call
    orders.each_with_object(Hash.new(0)) do |order, totals|
      totals[order[:customer_id]] += order[:total]
    end
  end

  private

  attr_reader :orders
end

# Result object pattern
Result = Struct.new(:success?, :value, :error, keyword_init: true)

class InventoryReservation
  def self.call(inventory:, sku:, quantity:)
    new(inventory: inventory, sku: sku, quantity: quantity).call
  end

  def initialize(inventory:, sku:, quantity:)
    @inventory = inventory
    @sku = sku
    @quantity = quantity
  end

  def call
    return failure("unknown sku") unless inventory.key?(sku)
    return failure("quantity must be positive") unless quantity.positive?
    return failure("insufficient inventory") if inventory[sku] < quantity

    inventory[sku] -= quantity
    Result.new(success?: true, value: inventory, error: nil)
  end

  private

  attr_reader :inventory, :sku, :quantity

  def failure(message)
    Result.new(success?: false, value: nil, error: message)
  end
end

# Dependency injection
class OrderNotifier
  def initialize(mailer:, logger:)
    @mailer = mailer
    @logger = logger
  end

  def call(order)
    mailer.deliver(order)
    logger.info("Sent order notification for order #{order[:id]}")
    true
  rescue StandardError => error
    logger.error("Failed to notify for order #{order[:id]}: #{error.message}")
    false
  end

  private

  attr_reader :mailer, :logger
end

# Separate parsing from business logic
class OrderCsvImporter
  def self.call(csv_rows)
    new(csv_rows).call
  end

  def initialize(csv_rows)
    @csv_rows = csv_rows
  end

  def call
    csv_rows.map { |row| parse_row(row) }
  end

  private

  attr_reader :csv_rows

  def parse_row(row)
    {
      order_id: row.fetch("order_id").to_i,
      customer_id: row.fetch("customer_id").to_i,
      total: row.fetch("total").to_f
    }
  end
end

# Pipeline-style objects
class NormalizeOrders
  def self.call(orders)
    orders.map do |order|
      {
        id: order[:id],
        customer_id: order[:customer_id].to_i,
        total: order[:total].to_f,
        status: order[:status].to_s.downcase
      }
    end
  end
end

class PaidOrderFilter
  def self.call(orders)
    orders.select { |order| order[:status] == "paid" }
  end
end

class RevenueTotal
  def self.call(orders)
    orders.sum { |order| order[:total] }
  end
end

# When to use:
# - business operation has multiple steps
# - logic does not naturally belong in a model/controller
# - you want easy unit tests
# - you need dependency injection
# - you want to keep Rails controllers thin
# Avoid wrapping one-line methods just to use a pattern.
