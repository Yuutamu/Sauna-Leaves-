module Customer::CartItemsHelper
  # MEMO:カート内商品の quantity の合計値をヘッダーに表示させるのでヘルパーとして定義
  def total_quantity(cart_items)
    cart_items.sum(:quantity)
  end
end
