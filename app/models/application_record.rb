class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  # MEMO:latest スコープはすべてのモデルに対して共通で利用したいので本モデルに定義することとする
  scope :latest, -> { order(created_at: :desc) }
end
