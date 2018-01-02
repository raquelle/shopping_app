class Item < ApplicationRecord
  belongs_to :list

  def show_price
    "#{self.name} costs #{self.price}"
  end
end
