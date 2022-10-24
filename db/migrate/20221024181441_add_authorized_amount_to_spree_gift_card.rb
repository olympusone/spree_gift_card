class AddAuthorizedAmountToSpreeGiftCard < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_gift_cards, :authorized_amount, :decimal, precision: 10, scale: 2, null: false, default: 0.0
  end
end
