module Spree
  module Api
    module V2
      module Storefront
        class GiftCardsController < ::Spree::Api::V2::ResourceController
          def index
            gift_card = Spree::Product.not_deleted.gift_cards.first
            
            render json: gift_card.as_json(include: [:images, :variants])
          end

          def create
            begin
              # Wrap the transaction script in a transaction so it is an atomic operation
              Spree::GiftCard.transaction do
                @gift_card = GiftCard.new(gift_card_params)
                @gift_card.save!
                
                # Create line item
                line_item = LineItem.new(quantity: 1)
                line_item.gift_card = @gift_card
                line_item.variant = @gift_card.variant
                line_item.price = @gift_card.variant.price

                # Add to order
                order = current_order(create_order_if_necessary: true)
                order.line_items << line_item
                line_item.order = order
                order.update_totals
                order.updater.update_item_count
                order.save!

                # Save gift card
                @gift_card.line_item = line_item
                @gift_card.save!
              end
            rescue ActiveRecord::RecordInvalid => e
              render json: e
            end
          end

          private
          def gift_card_params
            params.require(:gift_card).permit(:email, :name, :note, :variant_id, :sender_name, :sender_email)
          end
        end
      end
    end
  end
end
