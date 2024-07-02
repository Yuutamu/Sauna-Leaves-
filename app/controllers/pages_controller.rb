# TopPage 商品表示処理

class PagesController < ApplicationController
  def home
    @products = products_in_ascending
  end

  private

  # MEMO:おすすめ商品を価格の低い10商品を表示
  def products_in_ascending
    Product.price_low_to_high.limit(10)
  end
end
