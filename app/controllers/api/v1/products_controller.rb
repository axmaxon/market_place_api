class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show update]
  # Вернёт код 403 (forbidden) в заголовке ответа если current_user - falsy
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: :update


  def index
    render json: Product.all
  end

  def show
    render json: Product.find(params[:id])
  end

  # Создаёт новый инстанс продукта [в ассоциации] с юзером
  def create
    product = current_user.products.build(product_params)

    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def check_owner
    head :forbidden unless @product.user_id == current_user&.id
  end
end
