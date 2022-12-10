module Spree::LineItemDecorator
  MAXIMUM_GIFT_CARD_LIMIT ||= 1

  def self.prepended(base)
    base.has_one :gift_card, dependent: :destroy

    base.with_options if: :is_gift_card? do
      # TODO
      # validates :gift_card, presence: true
      validates :quantity,  numericality: { less_than_or_equal_to: MAXIMUM_GIFT_CARD_LIMIT }, allow_nil: true
    end

    base.delegate :is_gift_card?, to: :product

    base.accepts_nested_attributes_for :gift_card, reject_if: :all_blank, update_only: true
  end
end

Spree::LineItem.prepend Spree::LineItemDecorator
