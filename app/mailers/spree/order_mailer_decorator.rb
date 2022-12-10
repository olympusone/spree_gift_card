module Spree::OrderMailerDecorator
  def gift_card_email(card)
    @gift_card = card
    @order = card.list_item.order
    
    to = @order.user.email    
    reply_to_address = @current_store.customer_support_email
    subject = "#{Spree::Store.current.name} #{Spree.t('gift_card_email.subject')}"

    mail(
      to: to,
      from: from_address, reply_to: reply_to_address,
      subject: subject
    )
  end  
    
  protected
  def current_store(opts = {})
      @current_store = Spree::Store.find_by(id: opts[:current_store_id]) || Spree::Store.default
  end  
end

Spree::OrderMailer.prepend Spree::OrderMailerDecorator