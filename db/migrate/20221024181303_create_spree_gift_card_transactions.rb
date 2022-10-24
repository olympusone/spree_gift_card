class CreateSpreeGiftCardTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_gift_card_transactions do |t|
      t.decimal :amount, precision: 10, cale: 2 
      t.references :gift_card
      t.references :order
      t.timestamps
    end
  end
end
