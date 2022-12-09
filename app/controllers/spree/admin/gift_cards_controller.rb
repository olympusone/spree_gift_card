module Spree
  module Admin
    class GiftCardsController < ResourceController
      before_action :find_gift_card_variants, only: [:new, :edit]

      def create
        begin
          # Wrap the transaction script in a transaction so it is an atomic operation
          Spree::GiftCard.transaction do
            @gift_card = GiftCard.new(gift_card_params)
            @gift_card.current_value = @gift_card.variant.price
            @gift_card.save!

            # Create line item
            line_item = LineItem.new(quantity: 1)
            line_item.gift_card = @gift_card
            line_item.variant = @gift_card.variant
            line_item.price = @gift_card.variant.price

            # Add to order
            @order = Spree::Order.new(
              created_by_id: try_spree_current_user.try(:id),
              store_id: Spree::Store.current,
            )
            @order.line_items << line_item
            line_item.order = @order
            @order.update_totals
            @order.updater.update_item_count
            @order.save!

            # Save gift card
            @gift_card.line_item = line_item
            @gift_card.save!
          end

          redirect_to spree.edit_admin_order_url(@order)
        rescue ActiveRecord::RecordInvalid
          find_gift_card_variants
          render :new
        end
      end

      def update
        begin
          Spree::GiftCard.transaction do
            @gift_card.assign_attributes(gift_card_params)
           
            if @gift_card.variant_id_changed?
              @gift_card.current_value = @gift_card.variant.price

              @gift_card.line_item.update!(
                variant: @gift_card.variant,
                price: @gift_card.variant.price
              )
  
              @order = @gift_card.line_item.order

              # TODO is not updating adjustment properly i think
              
              @order.update_totals
              @order.updater.update_item_count
              @order.save!
            end

            @gift_card.save!
          end

          redirect_to spree.edit_admin_gift_card_url(@gift_card)
        rescue ActiveRecord::RecordInvalid
          find_gift_card_variants
          render :edit
        end
      end

      def destroy
        begin
          Spree::GiftCard.transaction do
            @order = @gift_card.line_item.order
            
            @gift_card.line_item.destroy

            @order.update_totals
            @order.updater.update_item_count
            @order.save!

            invoke_callbacks(:destroy, :before)
            if @gift_card.destroy
              invoke_callbacks(:destroy, :after)
              flash[:success] = flash_message_for(@gift_card, :successfully_removed)
            else
              invoke_callbacks(:destroy, :fails)
              flash[:error] = @gift_card.errors.full_messages.join(', ')
            end

            respond_with(@gift_card) do |format|
              format.html { redirect_to location_after_destroy }
              format.js   { render_js_for_destroy }
            end
          end
        rescue ActiveRecord::RecordInvalid
          # TODO
        end
      end
      
      private

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}
        @collection = super.order(created_at: :desc)

        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(params[:per_page])
      end

      def find_gift_card_variants
        @gift_card_product = Product.not_deleted.gift_cards.first
        
        @gift_card_variants = @gift_card_product.variants
                                                .joins(:prices)
                                                .where("amount > 0")
                                                .order("amount")
      end
  
      def gift_card_params
        params.require(:gift_card).permit(:email, :name, :note, :variant_id, :sender_name)
      end
    end
  end
end
