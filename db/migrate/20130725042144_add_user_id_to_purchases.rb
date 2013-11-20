class AddUserIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :user_id, :interger
  end
end
