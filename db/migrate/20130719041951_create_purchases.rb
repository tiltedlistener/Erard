class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :title
      t.float :price
      t.boolean :purchased
      t.references :student

      t.timestamps
    end
    add_index :purchases, :student_id
  end
end
