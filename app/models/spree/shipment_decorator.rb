module Spree::ShipmentDecorator
  def deliver_gift_cards
    gift_card_ids = line_items.
                      select(&:is_gift_card?).
                      map(&:gift_card).
                      map(&:id)

    return if gift_card_ids.none?

    Spree::GiftCard.where(id: gift_card_ids).each do |gift_card|
      Spree::OrderMailer.gift_card_email(gift_card.id, order).deliver_later
    end
  end
end

Spree::Shipment.prepend Spree::ShipmentDecorator
