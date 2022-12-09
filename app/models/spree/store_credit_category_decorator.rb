module Spree::StoreCreditCategoryDecorator
  def self.prepended(base)
    base.scope :gift_card, -> { where(name: 'Gift Card') }
  end
end

Spree::StoreCreditCategory.prepend Spree::StoreCreditCategoryDecorator
