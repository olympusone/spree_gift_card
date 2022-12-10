class CreateSpreeGiftCards < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_gift_cards do |t|
      t.references :variant, null: false
      t.integer :line_item_id
      t.string :email
      t.string :name
      t.string :sender_name
      t.text :note
      t.string :code, null: false
      t.decimal :current_value, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end
end
