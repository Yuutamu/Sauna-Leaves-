# TopPage 商品表示処理

class PagesController < ApplicationController
  def home
    @products = products_in_ascending
  end

  private

  # # MEMO:UI観点から、おすすめ商品を価格の高い３商品を表示
  # def products_in_descending
  #   Product.price_high_to_low.limit(3)
  # end

  # MEMO:おすすめ商品を価格の低い10商品を表示
  def products_in_ascending
    Product.price_low_to_high.limit(10)
  end
end
