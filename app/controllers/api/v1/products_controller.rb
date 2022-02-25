class Api::V1::ProductsController < ApplicationController
  # Вернёт код 403 (forbidden) в заголовке ответа если current_user - falsy
  before_action :check_login, only: %i[create]

  # Создаёт новый инстанс продукта [в ассоциации] с юзером
  def create
    product = current_user.products.build(product_params)

    if product.save
      render json: product, status: :created
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def index
    render json: Product.all
  end

  def show
    render json: Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :published)
  end
end
