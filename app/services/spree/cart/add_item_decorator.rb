module Spree::Cart::AddItemDecorator
  private

  # TODO make it more natural
  def add_to_line_item(order:, variant:, quantity: nil, options: {})
    options ||= {}
    quantity ||= 1

    line_item = Spree::Dependencies.line_item_by_variant_finder.constantize.new.execute(order: order, variant: variant, options: options)

    line_item_created = line_item.nil?
    if line_item.nil?
      opts = ::Spree::PermittedAttributes.line_item_attributes.flatten.each_with_object({}) do |attribute, result|
        result[attribute] = options[attribute]
      end.merge(currency: order.currency).delete_if { |_key, value| value.nil? }

      line_item = order.line_items.new(quantity: quantity,
                                        variant: variant,
                                        options: opts)
    else
      line_item.quantity += quantity.to_i
    end

    # our addition
    line_item.build_gift_card(options.require(:gift_card).permit!) if options.key? :gift_card

    line_item.target_shipment = options[:shipment] if options.key? :shipment

    return failure(line_item) unless line_item.save

    line_item.reload.update_price

    ::Spree::TaxRate.adjust(order, [line_item]) if line_item_created
    success(order: order, line_item: line_item, line_item_created: line_item_created, options: options)
  end
end
  
Spree::Cart::AddItem.prepend Spree::Cart::AddItemDecorator