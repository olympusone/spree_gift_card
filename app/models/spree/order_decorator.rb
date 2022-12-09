module Spree::OrderDecorator
  def self.prepended(base)
    base.include Spree::Order::GiftCard
  end
end

Spree::Order.prepend Spree::OrderDecorator
