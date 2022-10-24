module Spree
  module QuantifierCanSupply
    def can_supply?(required = 1)
      product = Spree::Variant.find(@variant).product
      super || product.is_gift_card?
    end
  end
end
