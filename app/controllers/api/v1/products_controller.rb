class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: %i[show update destroy]
  # Вернёт код 403 (forbidden) в заголовке ответа если current_user - falsy
  before_action :check_login, only: :create
  before_action :check_owner, only: %i[update destroy]

  def index
    @products = Product.all
    render json: ProductSerializer.new(@products).serializable_hash
  end

  def show
    # Опции для включения атрибутов пользователя, которому принадлежит продукт
    # (требуется также указание связи в сериализаторе)
    options = { include: [:user] }
    render json: ProductSerializer.new(@product, options).serializable_hash
  end

  # Создаёт новый инстанс продукта [в ассоциации] с юзером
  def create
    product = current_user.products.build(product_params)

    if product.save
      render json: ProductSerializer.new(product).serializable_hash, status: :created
    else
      render json: { errors: product.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: ProductSerializer.new(@product).serializable_hash
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head 204
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
