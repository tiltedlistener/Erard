class SetDefaultToPurchasedOnPurchases < ActiveRecord::Migration
  def change
    change_column :purchases, :purchased, :boolean, :default => false
  end
end
