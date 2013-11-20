class CreateNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
      t.string :subject
      t.text :body
      t.date :delivery_date
      t.references :user

      t.timestamps
    end
  end
end
