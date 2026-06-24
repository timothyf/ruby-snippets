# ruby_error_handling_validation_snippets.rb
# Ruby snippets for error handling, validation, and defensive programming.

require "json"
require "csv"

# Guard clauses
def normalize_email(email)
  raise ArgumentError, "email is required" if email.nil? || email.strip.empty?
  email.strip.downcase
end

# Optional parsing: return nil instead of raising.
def parse_integer_or_nil(value)
  Integer(value)
rescue ArgumentError, TypeError
  nil
end

# Required parsing: fail fast with a useful message.
def parse_required_integer(value, field_name:)
  Integer(value)
rescue ArgumentError, TypeError
  raise ArgumentError, "#{field_name} must be an integer"
end

# Required hash keys
def validate_required_keys!(hash, required_keys)
  missing = required_keys.reject { |key| hash.key?(key) }
  raise ArgumentError, "Missing required keys: #{missing.join(', ')}" unless missing.empty?
  true
end

# Numeric range validation
def validate_quantity!(quantity)
  quantity = parse_required_integer(quantity, field_name: "quantity")
  raise ArgumentError, "quantity must be positive" if quantity <= 0
  quantity
end

# Inclusion validation
VALID_STATUSES = %w[pending paid fulfilled canceled refunded].freeze

def validate_status!(status)
  status = status.to_s.strip.downcase
  unless VALID_STATUSES.include?(status)
    raise ArgumentError, "status must be one of: #{VALID_STATUSES.join(', ')}"
  end
  status
end

# Custom error classes
class InventoryError < StandardError; end
class InsufficientInventoryError < InventoryError; end
class UnknownSkuError < InventoryError; end

def reserve_inventory!(inventory, sku, quantity)
  raise UnknownSkuError, "unknown sku: #{sku}" unless inventory.key?(sku)
  raise ArgumentError, "quantity must be positive" if quantity <= 0
  raise InsufficientInventoryError, "not enough inventory for #{sku}" if inventory[sku] < quantity
  inventory[sku] -= quantity
end

# begin / rescue / ensure
def read_file_safely(path)
  file = File.open(path, "r")
  file.read
rescue Errno::ENOENT
  nil
ensure
  file&.close
end

# Prefer block form when possible. It closes the file automatically.
def read_file_safely_with_block(path)
  File.open(path, "r") { |file| file.read }
rescue Errno::ENOENT
  nil
end

# Retry with a limit
def with_retries(max_attempts: 3)
  attempts = 0
  begin
    attempts += 1
    yield
  rescue StandardError => error
    raise if attempts >= max_attempts
    warn "Attempt #{attempts} failed: #{error.message}. Retrying..."
    retry
  end
end

# Validate CSV row and collect errors instead of failing immediately.
def validate_order_row(row, line_number)
  errors = []
  errors << "line #{line_number}: order_id is required" if row["order_id"].to_s.strip.empty?
  errors << "line #{line_number}: customer_id is required" if row["customer_id"].to_s.strip.empty?
  errors << "line #{line_number}: total is required" if row["total"].to_s.strip.empty?
  errors << "line #{line_number}: total must be numeric" if parse_integer_or_nil(row["total"]).nil?
  errors
end

# Result object for non-exception flow.
Result = Struct.new(:success?, :value, :error, keyword_init: true)

def parse_json_result(text)
  Result.new(success?: true, value: JSON.parse(text, symbolize_names: true), error: nil)
rescue JSON::ParserError => error
  Result.new(success?: false, value: nil, error: error.message)
end

# Ensure cleanup.
def with_temp_file(path)
  File.write(path, "temporary data")
  yield path
ensure
  File.delete(path) if path && File.exist?(path)
end

# Avoid rescuing Exception. Prefer rescuing specific errors or StandardError.
# Interview phrases:
# - "I’ll validate at the boundary, then keep the core logic simple."
# - "For batch processing, I might collect row-level errors instead of failing immediately."
# - "I’m using a custom error so callers can distinguish expected domain failures."
