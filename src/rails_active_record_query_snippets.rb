# rails_active_record_query_snippets.rb
# Rails Active Record query snippets.
# Intended for Rails apps, not plain Ruby execution.

# Basic finders.
customer = Customer.find(1)
customer = Customer.find_by(email: "chris@example.com")
active_customers = Customer.where(active: true)
paid_orders = Order.where(status: "paid")

# where with ranges and arrays.
recent_orders = Order.where(created_at: 7.days.ago..Time.current)
selected_statuses = Order.where(status: ["paid", "fulfilled"])

# Negation.
not_canceled = Order.where.not(status: "canceled")
customers_with_email = Customer.where.not(email: nil)

# Ordering and limiting.
latest_orders = Order.order(created_at: :desc).limit(10)
largest_orders = Order.order(total_cents: :desc).limit(5)

# Selecting only needed columns.
emails = Customer.where(active: true).pluck(:email)
customer_ids = Order.where(status: "paid").distinct.pluck(:customer_id)

# Counting and aggregation.
order_count = Order.count
paid_count = Order.where(status: "paid").count
revenue_cents = Order.where(status: "paid").sum(:total_cents)
average_total = Order.where(status: "paid").average(:total_cents)

# group.
orders_by_status = Order.group(:status).count
revenue_by_customer = Order.where(status: "paid").group(:customer_id).sum(:total_cents)

# joins.
customers_with_paid_orders =
  Customer
    .joins(:orders)
    .where(orders: { status: "paid" })
    .distinct

# includes to avoid N+1 queries.
orders = Order.includes(:customer).limit(20)
orders.each { |order| puts order.customer.email }

# left_outer_joins.
customers_without_orders =
  Customer
    .left_outer_joins(:orders)
    .where(orders: { id: nil })

# scopes.
class Order < ApplicationRecord
  scope :paid, -> { where(status: "paid") }
  scope :recent, -> { where(created_at: 30.days.ago..Time.current) }
  scope :largest_first, -> { order(total_cents: :desc) }
end

Order.paid.recent.largest_first.limit(10)

# find_each for batch processing.
Order.where(status: "paid").find_each(batch_size: 1_000) do |order|
  # process one order at a time
end

# update_all and delete_all caution.
Order.where(status: "pending").update_all(status: "expired")
Order.where("created_at < ?", 2.years.ago).delete_all
# update_all skips validations/callbacks. delete_all skips callbacks.

# Transactions.
Order.transaction do
  order = Order.create!(customer: customer, status: "paid")
  InventoryReservation.create!(order: order, sku: "A100", quantity: 2)
end

# Locking row for update.
Order.transaction do
  inventory = Inventory.lock.find_by!(sku: "A100")
  raise "Not enough inventory" if inventory.quantity < 2
  inventory.update!(quantity: inventory.quantity - 2)
end

# Validations.
class Product < ApplicationRecord
  validates :sku, presence: true, uniqueness: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
end

# Notes:
# - Use pluck when you only need raw values.
# - Use includes when rendering associated records to avoid N+1 queries.
# - Use find_each for large backfills.
# - Use transactions when multiple writes must succeed or fail together.
# - Add indexes for columns used heavily in where/join/order clauses.
