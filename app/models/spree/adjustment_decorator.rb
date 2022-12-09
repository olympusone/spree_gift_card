module Spree::AdjustmentDecorator
  def self.prepended(base)
    base.scope :gift_card, -> { where(source_type: 'Spree::GiftCard') }
  end
end

Spree::Adjustment.prepend Spree::AdjustmentDecorator
