module Spree::PaymentMethodDecorator
  def self.prepended(base)
    base.scope :gift_card, -> { where(type: 'Spree::PaymentMethodMethod::GiftCard') }
  end

  def gift_card?
    self.class == Spree::PaymentMethodMethod::GiftCard
  end
end

Spree::PaymentMethod.prepend Spree::PaymentMethodDecorator
