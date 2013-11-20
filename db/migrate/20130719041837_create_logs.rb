class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.text :body
      t.references :student

      t.timestamps
    end
    add_index :logs, :student_id
  end
end
