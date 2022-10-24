class CreateSpreeUserGiftCards < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_user_gift_cards do |t|
      t.references :user
      t.references :gift_card
      t.timestamps
    end
  end
end
