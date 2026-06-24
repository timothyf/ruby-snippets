# ruby_csv_json_data_processing_snippets.rb
# Ruby snippets for CSV, JSON, JSON Lines, and common commerce-style data tasks.
#
# Run:
#   ruby ruby_csv_json_data_processing_snippets.rb

require "csv"
require "json"
require "fileutils"

FileUtils.mkdir_p("output")

# -----------------------------------------------------------------------------
# 1. Write CSV with headers
# -----------------------------------------------------------------------------

orders = [
  { order_id: 1, customer_id: 10, sku: "A100", quantity: 2, total: 25.50 },
  { order_id: 2, customer_id: 20, sku: "B200", quantity: 1, total: 13.00 },
  { order_id: 3, customer_id: 10, sku: "A100", quantity: 3, total: 10.00 }
]

CSV.open("output/orders.csv", "w", write_headers: true, headers: %w[order_id customer_id sku quantity total]) do |csv|
  orders.each do |order|
    csv << [
      order[:order_id],
      order[:customer_id],
      order[:sku],
      order[:quantity],
      order[:total]
    ]
  end
end

# -----------------------------------------------------------------------------
# 2. Read CSV with headers
# -----------------------------------------------------------------------------

CSV.foreach("output/orders.csv", headers: true) do |row|
  puts "#{row["order_id"]}: customer=#{row["customer_id"]}, total=#{row["total"]}"
end

# -----------------------------------------------------------------------------
# 3. Convert CSV rows to hashes with symbol keys
# -----------------------------------------------------------------------------

def csv_to_hashes(path)
  CSV.foreach(path, headers: true).map do |row|
    row.to_h.transform_keys(&:to_sym)
  end
end

puts csv_to_hashes("output/orders.csv").inspect

# -----------------------------------------------------------------------------
# 4. Validate required CSV columns
# -----------------------------------------------------------------------------

def validate_csv_headers!(path, required_headers)
  headers = CSV.open(path, &:readline)
  missing = required_headers - headers

  return true if missing.empty?

  raise ArgumentError, "Missing required CSV columns: #{missing.join(", ")}"
end

validate_csv_headers!("output/orders.csv", %w[order_id customer_id sku quantity total])

# -----------------------------------------------------------------------------
# 5. Stream CSV and process one row at a time
# -----------------------------------------------------------------------------

def total_revenue_from_csv(path)
  total = 0.0

  CSV.foreach(path, headers: true) do |row|
    total += row["total"].to_f
  end

  total
end

puts total_revenue_from_csv("output/orders.csv").round(2)

# -----------------------------------------------------------------------------
# 6. Group CSV orders by customer
# -----------------------------------------------------------------------------

def totals_by_customer_from_csv(path)
  totals = Hash.new(0.0)

  CSV.foreach(path, headers: true) do |row|
    totals[row["customer_id"]] += row["total"].to_f
  end

  totals
end

puts totals_by_customer_from_csv("output/orders.csv").inspect

# -----------------------------------------------------------------------------
# 7. Sum quantities by SKU
# -----------------------------------------------------------------------------

def quantities_by_sku_from_csv(path)
  quantities = Hash.new(0)

  CSV.foreach(path, headers: true) do |row|
    quantities[row["sku"]] += row["quantity"].to_i
  end

  quantities
end

puts quantities_by_sku_from_csv("output/orders.csv").inspect

# -----------------------------------------------------------------------------
# 8. Write a CSV report
# -----------------------------------------------------------------------------

def write_customer_totals_report(input_path, output_path)
  totals = totals_by_customer_from_csv(input_path)

  CSV.open(output_path, "w", write_headers: true, headers: %w[customer_id total]) do |csv|
    totals.each do |customer_id, total|
      csv << [customer_id, total.round(2)]
    end
  end
end

write_customer_totals_report("output/orders.csv", "output/customer_totals.csv")

# -----------------------------------------------------------------------------
# 9. Read JSON
# -----------------------------------------------------------------------------

customer = {
  id: 10,
  name: "Chris",
  email: "chris@example.com",
  tags: ["vip", "newsletter"]
}

File.write("output/customer.json", JSON.pretty_generate(customer))

loaded_customer = JSON.parse(File.read("output/customer.json"), symbolize_names: true)
puts loaded_customer[:email]

# -----------------------------------------------------------------------------
# 10. Write JSON
# -----------------------------------------------------------------------------

report = {
  generated_at: Time.now.utc.iso8601 rescue Time.now.utc.to_s,
  order_count: orders.length,
  total_revenue: orders.sum { |order| order[:total] }
}

File.write("output/report.json", JSON.pretty_generate(report))

# -----------------------------------------------------------------------------
# 11. Safe JSON parse
# -----------------------------------------------------------------------------

def safe_parse_json(text)
  JSON.parse(text, symbolize_names: true)
rescue JSON::ParserError
  nil
end

puts safe_parse_json('{"ok": true}').inspect
puts safe_parse_json("not json").inspect

# -----------------------------------------------------------------------------
# 12. JSON Lines / NDJSON write
# -----------------------------------------------------------------------------
# One JSON object per line. Good for logs, exports, and large data.

events = [
  { type: "order_created", order_id: 1 },
  { type: "order_paid", order_id: 1 },
  { type: "order_fulfilled", order_id: 1 }
]

File.open("output/events.jsonl", "w") do |file|
  events.each do |event|
    file.puts JSON.generate(event)
  end
end

# -----------------------------------------------------------------------------
# 13. JSON Lines / NDJSON stream read
# -----------------------------------------------------------------------------

File.foreach("output/events.jsonl") do |line|
  event = JSON.parse(line, symbolize_names: true)
  puts "#{event[:type]} for order #{event[:order_id]}"
end

# -----------------------------------------------------------------------------
# 14. Convert CSV to JSON
# -----------------------------------------------------------------------------

def csv_to_json_file(csv_path, json_path)
  records = CSV.foreach(csv_path, headers: true).map do |row|
    row.to_h
  end

  File.write(json_path, JSON.pretty_generate(records))
end

csv_to_json_file("output/orders.csv", "output/orders.json")

# -----------------------------------------------------------------------------
# 15. Convert JSON array to CSV
# -----------------------------------------------------------------------------

def json_array_to_csv(json_path, csv_path)
  records = JSON.parse(File.read(json_path))
  return if records.empty?

  headers = records.first.keys

  CSV.open(csv_path, "w", write_headers: true, headers: headers) do |csv|
    records.each do |record|
      csv << headers.map { |header| record[header] }
    end
  end
end

json_array_to_csv("output/orders.json", "output/orders_roundtrip.csv")

# -----------------------------------------------------------------------------
# 16. Normalize messy CSV values
# -----------------------------------------------------------------------------

def normalize_order_row(row)
  {
    order_id: row["order_id"].to_i,
    customer_id: row["customer_id"].to_i,
    sku: row["sku"].to_s.strip,
    quantity: row["quantity"].to_i,
    total: row["total"].to_f
  }
end

normalized = CSV.foreach("output/orders.csv", headers: true).map do |row|
  normalize_order_row(row)
end

puts normalized.inspect

# -----------------------------------------------------------------------------
# 17. Filter records and export
# -----------------------------------------------------------------------------

def export_paid_orders(records, path)
  CSV.open(path, "w", write_headers: true, headers: %w[order_id customer_id total]) do |csv|
    records.each do |record|
      next unless record[:status] == "paid"

      csv << [record[:order_id], record[:customer_id], record[:total]]
    end
  end
end

paid_orders = [
  { order_id: 1, customer_id: 10, total: 25.50, status: "paid" },
  { order_id: 2, customer_id: 20, total: 13.00, status: "pending" }
]

export_paid_orders(paid_orders, "output/paid_orders.csv")

# -----------------------------------------------------------------------------
# 18. Stream transform large CSV
# -----------------------------------------------------------------------------

def transform_csv(input_path, output_path)
  CSV.open(output_path, "w", write_headers: true, headers: %w[order_id customer_id total_cents]) do |output|
    CSV.foreach(input_path, headers: true) do |row|
      total_cents = (row["total"].to_f * 100).round
      output << [row["order_id"], row["customer_id"], total_cents]
    end
  end
end

transform_csv("output/orders.csv", "output/orders_cents.csv")

# -----------------------------------------------------------------------------
# Interview notes
# -----------------------------------------------------------------------------
#
# CSV.foreach                      => stream a CSV row-by-row
# CSV.read                         => load the whole CSV; small files only
# CSV.open(..., write_headers: true) => create a CSV report
# JSON.parse                       => parse a JSON string
# JSON.pretty_generate             => readable JSON output
# JSON.generate                    => compact JSON output
# JSON Lines                       => good for streaming large event data
#
# Staff-level notes:
# - Validate required columns before processing.
# - Normalize types at the boundary: strings from CSV become integers/floats.
# - Stream large files instead of loading them all into memory.
# - Separate parsing from business logic.
# - Decide what to do with invalid rows: skip, collect errors, or fail fast.
