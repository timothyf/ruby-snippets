# Method Index

This index lists every method definition under `src/` in two ways:

- by category
- by snippet file

## By Category

### Aggregation And Frequency

- [frequencies(values)](src/ruby_algorithm_patterns_snippets.rb#L13)
- [most_frequent(values)](src/ruby_algorithm_patterns_snippets.rb#L25)
- [totals_by_customer_from_csv(path)](src/ruby_csv_json_data_processing_snippets.rb#L90)
- [quantities_by_sku_from_csv(path)](src/ruby_csv_json_data_processing_snippets.rb#L106)
- [totals_by_customer(orders)](src/ruby_data_transformation_patterns_snippets.rb.rb#L9)
- [most_frequent_item(items)](src/ruby_data_transformation_patterns_snippets.rb.rb#L123)
- [most_frequent_item_with_count(items)](src/ruby_data_transformation_patterns_snippets.rb.rb#L143)
- [totals_by_customer(orders)](src/ruby_refactoring_patterns_snippets.rb#L43)
- [most_frequent_first_seen(values)](src/ruby_refactoring_patterns_snippets.rb#L68)
- [CustomerTotals.call(orders)](src/ruby_service_object_snippets.rb#L6)
- [CustomerTotals#call](src/ruby_service_object_snippets.rb#L14)
- [totals_by_customer(orders)](src/ruby_testing_snippets.rb#L21)
- [totals_by_date(records)](src/ruby_time_date_snippets.rb#L63)

### Arrays Collections And Deduping

- [dedupe_preserving_order(values)](src/ruby_collections_snippets.rb#L159)
- [dedupe_preserving_order(items)](src/ruby_data_transformation_patterns_snippets.rb.rb#L98)
- [active_vip_customers(customers)](src/ruby_refactoring_patterns_snippets.rb#L50)
- [active_vip_customer?(customer)](src/ruby_refactoring_patterns_snippets.rb#L54)
- [dedupe_preserving_order(values)](src/ruby_testing_snippets.rb#L31)

### Search Graph And Combinatorics

- [pair_sum?(numbers, target)](src/ruby_algorithm_patterns_snippets.rb#L50)
- [binary_search(numbers, target)](src/ruby_algorithm_patterns_snippets.rb#L137)
- [bfs(graph, start)](src/ruby_algorithm_patterns_snippets.rb#L187)
- [dfs_recursive(graph, node, visited = Set.new, order = [])](src/ruby_algorithm_patterns_snippets.rb#L222)
- [dfs_iterative(graph, start)](src/ruby_algorithm_patterns_snippets.rb#L241)
- [dependency_order(tasks, dependencies)](src/ruby_algorithm_patterns_snippets.rb#L268)
- [combinations(values, size)](src/ruby_algorithm_patterns_snippets.rb#L309)
- [fibonacci(n, memo = {})](src/ruby_algorithm_patterns_snippets.rb#L336)
- [dependency_order(tasks, dependencies)](src/ruby_data_transformation_patterns_snippets.rb.rb#L235)

### Sliding Window And Intervals

- [longest_substring_at_most_k_distinct(text, k)](src/ruby_algorithm_patterns_snippets.rb#L75)
- [longest_subarray_sum_at_most(numbers, target)](src/ruby_algorithm_patterns_snippets.rb#L112)
- [merge_intervals(intervals)](src/ruby_algorithm_patterns_snippets.rb#L162)
- [longest_substring_at_most_k_distinct(s, k)](src/ruby_data_transformation_patterns_snippets.rb.rb#L370)
- [longest_subarray_sum_at_most(nums, target)](src/ruby_data_transformation_patterns_snippets.rb.rb#L409)
- [merge_intervals(intervals)](src/ruby_data_transformation_patterns_snippets.rb.rb#L172)
- [merge_intervals_by_hash(intervals)](src/ruby_data_transformation_patterns_snippets.rb.rb#L202)
- [merge_intervals(intervals)](src/ruby_testing_snippets.rb#L45)
- [merge_time_intervals(intervals)](src/ruby_time_date_snippets.rb#L79)

### Trees Nested Data And Transformation

- [csv_to_hashes(path)](src/ruby_csv_json_data_processing_snippets.rb#L47)
- [normalize_order_row(row)](src/ruby_csv_json_data_processing_snippets.rb#L238)
- [transform_csv(input_path, output_path)](src/ruby_csv_json_data_processing_snippets.rb#L279)
- [active_products(category)](src/ruby_data_transformation_patterns_snippets.rb.rb#L281)
- [collect_active_products(category, result)](src/ruby_data_transformation_patterns_snippets.rb.rb#L287)
- [active_products_with_path(category)](src/ruby_data_transformation_patterns_snippets.rb.rb#L302)
- [collect_with_path(category, path, result)](src/ruby_data_transformation_patterns_snippets.rb.rb#L308)
- [active_products_iterative(category)](src/ruby_data_transformation_patterns_snippets.rb.rb#L322)
- [parse_order(row)](src/ruby_refactoring_patterns_snippets.rb#L35)
- [normalized_order(order)](src/ruby_refactoring_patterns_snippets.rb#L59)
- [OrderCsvImporter#call](src/ruby_service_object_snippets.rb#L88)
- [OrderCsvImporter#parse_row(row)](src/ruby_service_object_snippets.rb#L96)
- [NormalizeOrders.call(orders)](src/ruby_service_object_snippets.rb#L107)

### CSV JSON And Export

- [validate_csv_headers!(path, required_headers)](src/ruby_csv_json_data_processing_snippets.rb#L59)
- [total_revenue_from_csv(path)](src/ruby_csv_json_data_processing_snippets.rb#L74)
- [write_customer_totals_report(input_path, output_path)](src/ruby_csv_json_data_processing_snippets.rb#L122)
- [safe_parse_json(text)](src/ruby_csv_json_data_processing_snippets.rb#L166)
- [csv_to_json_file(csv_path, json_path)](src/ruby_csv_json_data_processing_snippets.rb#L205)
- [json_array_to_csv(json_path, csv_path)](src/ruby_csv_json_data_processing_snippets.rb#L219)
- [export_paid_orders(records, path)](src/ruby_csv_json_data_processing_snippets.rb#L258)
- [parse_json_result(text)](src/ruby_error_handling_validation_snippets.rb#L107)

### Validation Parsing And Retries

- [normalize_email(email)](src/ruby_error_handling_validation_snippets.rb#L8)
- [parse_integer_or_nil(value)](src/ruby_error_handling_validation_snippets.rb#L14)
- [parse_required_integer(value, field_name:)](src/ruby_error_handling_validation_snippets.rb#L21)
- [validate_required_keys!(hash, required_keys)](src/ruby_error_handling_validation_snippets.rb#L28)
- [validate_quantity!(quantity)](src/ruby_error_handling_validation_snippets.rb#L35)
- [validate_status!(status)](src/ruby_error_handling_validation_snippets.rb#L44)
- [with_retries(max_attempts: 3)](src/ruby_error_handling_validation_snippets.rb#L82)
- [validate_order_row(row, line_number)](src/ruby_error_handling_validation_snippets.rb#L95)
- [parse_positive_integer(value)](src/ruby_testing_snippets.rb#L64)

### Filesystem And Text I O

- [read_file_safely(path)](src/ruby_error_handling_validation_snippets.rb#L65)
- [read_file_safely_with_block(path)](src/ruby_error_handling_validation_snippets.rb#L75)
- [with_temp_file(path)](src/ruby_error_handling_validation_snippets.rb#L114)
- [atomic_write(path, contents)](src/ruby_file_io_snippets.rb#L157)
- [count_csv_rows(path)](src/ruby_file_io_snippets.rb#L241)
- [total_bytes_under(directory)](src/ruby_file_io_snippets.rb#L313)
- [read_required_file(path)](src/ruby_file_io_snippets.rb#L374)
- [uppercase_file(input_path, output_path)](src/ruby_file_io_snippets.rb#L389)
- [read_key_value_file(path)](src/ruby_file_io_snippets.rb#L414)
- [log_line(path, message)](src/ruby_file_io_snippets.rb#L437)
- [count_csv_rows(path)](src/ruby_testing_snippets.rb#L71)

### Orders Inventory And Commerce

- [Api::InventoryReservationsController#create](src/rails_api_controller_snippets.rb#L86)
- [Api::InventoryReservationsController#reservation_params](src/rails_api_controller_snippets.rb#L101)
- [can_fulfill?(stock_events, purchase_events, sku)](src/ruby_data_transformation_patterns_snippets.rb.rb#L37)
- [can_fulfill_over_time?(events, sku)](src/ruby_data_transformation_patterns_snippets.rb.rb#L63)
- [reserve_inventory!(inventory, sku, quantity)](src/ruby_error_handling_validation_snippets.rb#L57)
- [discount_for(order)](src/ruby_refactoring_patterns_snippets.rb#L5)
- [eligible_for_free_shipping?(order)](src/ruby_refactoring_patterns_snippets.rb#L13)
- [domestic_order?(order)](src/ruby_refactoring_patterns_snippets.rb#L17)
- [paid?(order)](src/ruby_refactoring_patterns_snippets.rb#L30)
- [create_order(customer_id:, sku:, quantity:, total:)](src/ruby_refactoring_patterns_snippets.rb#L85)
- [Inventory#initialize(stock)](src/ruby_refactoring_patterns_snippets.rb#L91)
- [Inventory#available?(sku, quantity)](src/ruby_refactoring_patterns_snippets.rb#L95)
- [Inventory#reserve(sku, quantity)](src/ruby_refactoring_patterns_snippets.rb#L99)
- [InventoryReservation.call(inventory:, sku:, quantity:)](src/ruby_service_object_snippets.rb#L29)
- [InventoryReservation#initialize(inventory:, sku:, quantity:)](src/ruby_service_object_snippets.rb#L33)
- [InventoryReservation#call](src/ruby_service_object_snippets.rb#L39)
- [InventoryReservation#failure(message)](src/ruby_service_object_snippets.rb#L52)
- [PaidOrderFilter.call(orders)](src/ruby_service_object_snippets.rb#L120)
- [RevenueTotal.call(orders)](src/ruby_service_object_snippets.rb#L126)

### Controllers And HTTP

- [Api::OrdersController#index](src/rails_api_controller_snippets.rb#L7)
- [Api::OrdersController#show](src/rails_api_controller_snippets.rb#L12)
- [Api::ProductsController#create](src/rails_api_controller_snippets.rb#L23)
- [Api::ProductsController#product_params](src/rails_api_controller_snippets.rb#L35)
- [Api::CustomersController#update](src/rails_api_controller_snippets.rb#L42)
- [Api::CustomersController#customer_params](src/rails_api_controller_snippets.rb#L54)
- [Api::ProductsController#destroy](src/rails_api_controller_snippets.rb#L61)
- [Api::BaseController#render_not_found](src/rails_api_controller_snippets.rb#L75)
- [Api::BaseController#render_bad_request](src/rails_api_controller_snippets.rb#L79)
- [Api::PaginatedOrdersController#index](src/rails_api_controller_snippets.rb#L108)

### Service Objects And Collaboration

- [CustomerTotals#initialize(orders)](src/ruby_service_object_snippets.rb#L10)
- [OrderNotifier#initialize(mailer:, logger:)](src/ruby_service_object_snippets.rb#L59)
- [OrderNotifier#call(order)](src/ruby_service_object_snippets.rb#L64)
- [OrderCsvImporter.call(csv_rows)](src/ruby_service_object_snippets.rb#L80)
- [OrderCsvImporter#initialize(csv_rows)](src/ruby_service_object_snippets.rb#L84)

### Date Time And Scheduling

- [beginning_of_day(date)](src/ruby_time_date_snippets.rb#L34)
- [end_of_day(date)](src/ruby_time_date_snippets.rb#L38)
- [dates_between(start_date, end_date)](src/ruby_time_date_snippets.rb#L43)
- [within_window?(timestamp, start_time, end_time)](src/ruby_time_date_snippets.rb#L48)
- [sort_by_created_at(records)](src/ruby_time_date_snippets.rb#L53)
- [group_by_date(records)](src/ruby_time_date_snippets.rb#L58)
- [duration_minutes(started_at, finished_at)](src/ruby_time_date_snippets.rb#L70)

### Testing Helpers

- [assert_equal(expected, actual)](src/ruby_testing_snippets.rb#L177)
- [assert(condition, message = "Assertion failed")](src/ruby_testing_snippets.rb#L183)

## By File

## rails_active_record_query_snippets.rb

No method definitions. This file contains Active Record query examples, scopes, transactions, and validations.

## rails_api_controller_snippets.rb

- [Api::OrdersController#index](src/rails_api_controller_snippets.rb#L7)
- [Api::OrdersController#show](src/rails_api_controller_snippets.rb#L12)
- [Api::ProductsController#create](src/rails_api_controller_snippets.rb#L23)
- [Api::ProductsController#product_params](src/rails_api_controller_snippets.rb#L35)
- [Api::CustomersController#update](src/rails_api_controller_snippets.rb#L42)
- [Api::CustomersController#customer_params](src/rails_api_controller_snippets.rb#L54)
- [Api::ProductsController#destroy](src/rails_api_controller_snippets.rb#L61)
- [Api::BaseController#render_not_found](src/rails_api_controller_snippets.rb#L75)
- [Api::BaseController#render_bad_request](src/rails_api_controller_snippets.rb#L79)
- [Api::InventoryReservationsController#create](src/rails_api_controller_snippets.rb#L86)
- [Api::InventoryReservationsController#reservation_params](src/rails_api_controller_snippets.rb#L101)
- [Api::PaginatedOrdersController#index](src/rails_api_controller_snippets.rb#L108)

## ruby_algorithm_patterns_snippets.rb

- [frequencies(values)](src/ruby_algorithm_patterns_snippets.rb#L13)
- [most_frequent(values)](src/ruby_algorithm_patterns_snippets.rb#L25)
- [pair_sum?(numbers, target)](src/ruby_algorithm_patterns_snippets.rb#L50)
- [longest_substring_at_most_k_distinct(text, k)](src/ruby_algorithm_patterns_snippets.rb#L75)
- [longest_subarray_sum_at_most(numbers, target)](src/ruby_algorithm_patterns_snippets.rb#L112)
- [binary_search(numbers, target)](src/ruby_algorithm_patterns_snippets.rb#L137)
- [merge_intervals(intervals)](src/ruby_algorithm_patterns_snippets.rb#L162)
- [bfs(graph, start)](src/ruby_algorithm_patterns_snippets.rb#L187)
- [dfs_recursive(graph, node, visited = Set.new, order = [])](src/ruby_algorithm_patterns_snippets.rb#L222)
- [dfs_iterative(graph, start)](src/ruby_algorithm_patterns_snippets.rb#L241)
- [dependency_order(tasks, dependencies)](src/ruby_algorithm_patterns_snippets.rb#L268)
- [combinations(values, size)](src/ruby_algorithm_patterns_snippets.rb#L309)
- [fibonacci(n, memo = {})](src/ruby_algorithm_patterns_snippets.rb#L336)

## ruby_collections_snippets.rb

- [dedupe_preserving_order(values)](src/ruby_collections_snippets.rb#L159)

## ruby_csv_json_data_processing_snippets.rb

- [csv_to_hashes(path)](src/ruby_csv_json_data_processing_snippets.rb#L47)
- [validate_csv_headers!(path, required_headers)](src/ruby_csv_json_data_processing_snippets.rb#L59)
- [total_revenue_from_csv(path)](src/ruby_csv_json_data_processing_snippets.rb#L74)
- [totals_by_customer_from_csv(path)](src/ruby_csv_json_data_processing_snippets.rb#L90)
- [quantities_by_sku_from_csv(path)](src/ruby_csv_json_data_processing_snippets.rb#L106)
- [write_customer_totals_report(input_path, output_path)](src/ruby_csv_json_data_processing_snippets.rb#L122)
- [safe_parse_json(text)](src/ruby_csv_json_data_processing_snippets.rb#L166)
- [csv_to_json_file(csv_path, json_path)](src/ruby_csv_json_data_processing_snippets.rb#L205)
- [json_array_to_csv(json_path, csv_path)](src/ruby_csv_json_data_processing_snippets.rb#L219)
- [normalize_order_row(row)](src/ruby_csv_json_data_processing_snippets.rb#L238)
- [export_paid_orders(records, path)](src/ruby_csv_json_data_processing_snippets.rb#L258)
- [transform_csv(input_path, output_path)](src/ruby_csv_json_data_processing_snippets.rb#L279)

## ruby_data_transformation_patterns_snippets.rb.rb

- [totals_by_customer(orders)](src/ruby_data_transformation_patterns_snippets.rb.rb#L9)
- [can_fulfill?(stock_events, purchase_events, sku)](src/ruby_data_transformation_patterns_snippets.rb.rb#L37)
- [can_fulfill_over_time?(events, sku)](src/ruby_data_transformation_patterns_snippets.rb.rb#L63)
- [dedupe_preserving_order(items)](src/ruby_data_transformation_patterns_snippets.rb.rb#L98)
- [most_frequent_item(items)](src/ruby_data_transformation_patterns_snippets.rb.rb#L123)
- [most_frequent_item_with_count(items)](src/ruby_data_transformation_patterns_snippets.rb.rb#L143)
- [merge_intervals(intervals)](src/ruby_data_transformation_patterns_snippets.rb.rb#L172)
- [merge_intervals_by_hash(intervals)](src/ruby_data_transformation_patterns_snippets.rb.rb#L202)
- [dependency_order(tasks, dependencies)](src/ruby_data_transformation_patterns_snippets.rb.rb#L235)
- [active_products(category)](src/ruby_data_transformation_patterns_snippets.rb.rb#L281)
- [collect_active_products(category, result)](src/ruby_data_transformation_patterns_snippets.rb.rb#L287)
- [active_products_with_path(category)](src/ruby_data_transformation_patterns_snippets.rb.rb#L302)
- [collect_with_path(category, path, result)](src/ruby_data_transformation_patterns_snippets.rb.rb#L308)
- [active_products_iterative(category)](src/ruby_data_transformation_patterns_snippets.rb.rb#L322)
- [longest_substring_at_most_k_distinct(s, k)](src/ruby_data_transformation_patterns_snippets.rb.rb#L370)
- [longest_subarray_sum_at_most(nums, target)](src/ruby_data_transformation_patterns_snippets.rb.rb#L409)

## ruby_error_handling_validation_snippets.rb

- [normalize_email(email)](src/ruby_error_handling_validation_snippets.rb#L8)
- [parse_integer_or_nil(value)](src/ruby_error_handling_validation_snippets.rb#L14)
- [parse_required_integer(value, field_name:)](src/ruby_error_handling_validation_snippets.rb#L21)
- [validate_required_keys!(hash, required_keys)](src/ruby_error_handling_validation_snippets.rb#L28)
- [validate_quantity!(quantity)](src/ruby_error_handling_validation_snippets.rb#L35)
- [validate_status!(status)](src/ruby_error_handling_validation_snippets.rb#L44)
- [reserve_inventory!(inventory, sku, quantity)](src/ruby_error_handling_validation_snippets.rb#L57)
- [read_file_safely(path)](src/ruby_error_handling_validation_snippets.rb#L65)
- [read_file_safely_with_block(path)](src/ruby_error_handling_validation_snippets.rb#L75)
- [with_retries(max_attempts: 3)](src/ruby_error_handling_validation_snippets.rb#L82)
- [validate_order_row(row, line_number)](src/ruby_error_handling_validation_snippets.rb#L95)
- [parse_json_result(text)](src/ruby_error_handling_validation_snippets.rb#L107)
- [with_temp_file(path)](src/ruby_error_handling_validation_snippets.rb#L114)

## ruby_file_io_snippets.rb

- [atomic_write(path, contents)](src/ruby_file_io_snippets.rb#L157)
- [count_csv_rows(path)](src/ruby_file_io_snippets.rb#L241)
- [total_bytes_under(directory)](src/ruby_file_io_snippets.rb#L313)
- [read_required_file(path)](src/ruby_file_io_snippets.rb#L374)
- [uppercase_file(input_path, output_path)](src/ruby_file_io_snippets.rb#L389)
- [read_key_value_file(path)](src/ruby_file_io_snippets.rb#L414)
- [log_line(path, message)](src/ruby_file_io_snippets.rb#L437)

## ruby_refactoring_patterns_snippets.rb

- [discount_for(order)](src/ruby_refactoring_patterns_snippets.rb#L5)
- [eligible_for_free_shipping?(order)](src/ruby_refactoring_patterns_snippets.rb#L13)
- [domestic_order?(order)](src/ruby_refactoring_patterns_snippets.rb#L17)
- [paid?(order)](src/ruby_refactoring_patterns_snippets.rb#L30)
- [parse_order(row)](src/ruby_refactoring_patterns_snippets.rb#L35)
- [totals_by_customer(orders)](src/ruby_refactoring_patterns_snippets.rb#L43)
- [active_vip_customers(customers)](src/ruby_refactoring_patterns_snippets.rb#L50)
- [active_vip_customer?(customer)](src/ruby_refactoring_patterns_snippets.rb#L54)
- [normalized_order(order)](src/ruby_refactoring_patterns_snippets.rb#L59)
- [most_frequent_first_seen(values)](src/ruby_refactoring_patterns_snippets.rb#L68)
- [create_order(customer_id:, sku:, quantity:, total:)](src/ruby_refactoring_patterns_snippets.rb#L85)
- [Inventory#initialize(stock)](src/ruby_refactoring_patterns_snippets.rb#L91)
- [Inventory#available?(sku, quantity)](src/ruby_refactoring_patterns_snippets.rb#L95)
- [Inventory#reserve(sku, quantity)](src/ruby_refactoring_patterns_snippets.rb#L99)

## ruby_service_object_snippets.rb

- [CustomerTotals.call(orders)](src/ruby_service_object_snippets.rb#L6)
- [CustomerTotals#initialize(orders)](src/ruby_service_object_snippets.rb#L10)
- [CustomerTotals#call](src/ruby_service_object_snippets.rb#L14)
- [InventoryReservation.call(inventory:, sku:, quantity:)](src/ruby_service_object_snippets.rb#L29)
- [InventoryReservation#initialize(inventory:, sku:, quantity:)](src/ruby_service_object_snippets.rb#L33)
- [InventoryReservation#call](src/ruby_service_object_snippets.rb#L39)
- [InventoryReservation#failure(message)](src/ruby_service_object_snippets.rb#L52)
- [OrderNotifier#initialize(mailer:, logger:)](src/ruby_service_object_snippets.rb#L59)
- [OrderNotifier#call(order)](src/ruby_service_object_snippets.rb#L64)
- [OrderCsvImporter.call(csv_rows)](src/ruby_service_object_snippets.rb#L80)
- [OrderCsvImporter#initialize(csv_rows)](src/ruby_service_object_snippets.rb#L84)
- [OrderCsvImporter#call](src/ruby_service_object_snippets.rb#L88)
- [OrderCsvImporter#parse_row(row)](src/ruby_service_object_snippets.rb#L96)
- [NormalizeOrders.call(orders)](src/ruby_service_object_snippets.rb#L107)
- [PaidOrderFilter.call(orders)](src/ruby_service_object_snippets.rb#L120)
- [RevenueTotal.call(orders)](src/ruby_service_object_snippets.rb#L126)

## ruby_testing_snippets.rb

- [totals_by_customer(orders)](src/ruby_testing_snippets.rb#L21)
- [dedupe_preserving_order(values)](src/ruby_testing_snippets.rb#L31)
- [merge_intervals(intervals)](src/ruby_testing_snippets.rb#L45)
- [parse_positive_integer(value)](src/ruby_testing_snippets.rb#L64)
- [count_csv_rows(path)](src/ruby_testing_snippets.rb#L71)
- [assert_equal(expected, actual)](src/ruby_testing_snippets.rb#L177)
- [assert(condition, message = "Assertion failed")](src/ruby_testing_snippets.rb#L183)

## ruby_time_date_snippets.rb

- [beginning_of_day(date)](src/ruby_time_date_snippets.rb#L34)
- [end_of_day(date)](src/ruby_time_date_snippets.rb#L38)
- [dates_between(start_date, end_date)](src/ruby_time_date_snippets.rb#L43)
- [within_window?(timestamp, start_time, end_time)](src/ruby_time_date_snippets.rb#L48)
- [sort_by_created_at(records)](src/ruby_time_date_snippets.rb#L53)
- [group_by_date(records)](src/ruby_time_date_snippets.rb#L58)
- [totals_by_date(records)](src/ruby_time_date_snippets.rb#L63)
- [duration_minutes(started_at, finished_at)](src/ruby_time_date_snippets.rb#L70)
- [merge_time_intervals(intervals)](src/ruby_time_date_snippets.rb#L79)