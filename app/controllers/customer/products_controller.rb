class Customer::ProductsController < ApplicationController
  def index
    @products, @sort = get_products(params)
  end

  def show
    @product = Product.find(params[:id])
    @cart_item = CartItem.new # MEMO:商品詳細ページにカート追加ボタンを設置
  end

  private

  def get_products(params)
    return Product.all, 'default' unless params[:latest] || params[:price_high_to_low] || params[:price_low_to_high]

    return Product.latest, 'latest' if params[:latest]

    return Product.price.price_high_to_low, 'price_high_to_low' if params[:price_high_to_low]

    [Product.price.price_low_to_high, 'price_low_to_high'] if params[:price_low_to_high]
  end
end
