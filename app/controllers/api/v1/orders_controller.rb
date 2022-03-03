class Api::V1::OrdersController < ApplicationController
  before_action :check_login, only: :index

  def index
    render json: OrderSerializer.new(current_user.orders).serializable_hash
  end

  def show
    order = current_user.orders.find(params[:id])

    if order
      # Опции для включения в вывод атрибутов продуктов, которые связаны с заказом
      # (требуется также указание связи в сериализаторе)
      options = { include: [:products] }
      render json: OrderSerializer.new(order, options).serializable_hash
    else
      head 404
    end
  end
end
