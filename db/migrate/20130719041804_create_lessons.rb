class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.date :date
      t.time :time
      t.references :student
      t.boolean :paid

      t.timestamps
    end
    add_index :lessons, :student_id
  end
end
