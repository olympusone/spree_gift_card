class AddGiftCardAttrToSpreeProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :spree_products, :is_gift_card, :boolean, default: false, null: false
    add_column :spree_products, :is_e_gift_card, :boolean, default: false, null: false
  end
end
