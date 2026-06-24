# rails_api_controller_snippets.rb
# Rails API controller snippets.
# Intended for Rails apps, not plain Ruby execution.

# Basic JSON controller.
class Api::OrdersController < ApplicationController
  def index
    orders = Order.order(created_at: :desc).limit(50)
    render json: orders.as_json(only: [:id, :status, :total_cents, :created_at])
  end

  def show
    order = Order.find(params[:id])
    render json: order.as_json(
      only: [:id, :status, :total_cents, :created_at],
      include: { customer: { only: [:id, :email] } }
    )
  end
end

# Create action with strong params.
class Api::ProductsController < ApplicationController
  def create
    product = Product.new(product_params)

    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:sku, :name, :price_cents)
  end
end

# Update action.
class Api::CustomersController < ApplicationController
  def update
    customer = Customer.find(params[:id])

    if customer.update(customer_params)
      render json: customer
    else
      render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:email, :name, :active)
  end
end

# Destroy action.
class Api::ProductsController < ApplicationController
  def destroy
    product = Product.find(params[:id])
    product.destroy!
    head :no_content
  end
end

# Consistent error handling.
class Api::BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def render_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def render_bad_request(error)
    render json: { error: error.message }, status: :bad_request
  end
end

# Controller using a service object.
class Api::InventoryReservationsController < Api::BaseController
  def create
    result = InventoryReservation.call(
      sku: reservation_params[:sku],
      quantity: reservation_params[:quantity].to_i
    )

    if result.success?
      render json: { inventory: result.value }, status: :created
    else
      render json: { error: result.error }, status: :unprocessable_entity
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:sku, :quantity)
  end
end

# Simple pagination.
class Api::PaginatedOrdersController < Api::BaseController
  def index
    page = params.fetch(:page, 1).to_i
    per_page = [params.fetch(:per_page, 25).to_i, 100].min

    orders = Order.order(created_at: :desc).offset((page - 1) * per_page).limit(per_page)

    render json: {
      data: orders.as_json(only: [:id, :status, :total_cents]),
      meta: { page: page, per_page: per_page }
    }
  end
end

# Status code reminders:
# 200 OK, 201 Created, 204 No Content, 400 Bad Request, 401 Unauthorized,
# 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable Entity.
#
# Notes:
# - Keep controllers thin.
# - Use strong params.
# - Return consistent error shapes.
# - Avoid exposing internal fields accidentally.
# - Delegate business logic to service objects.
