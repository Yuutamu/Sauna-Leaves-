class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :product

  # TODO: メソッド名わかりにくいので、変更する
  def line_total
    product.price * quantity
  end
end
