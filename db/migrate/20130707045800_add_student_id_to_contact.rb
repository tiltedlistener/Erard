class AddStudentIdToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :student_id, :integer
    add_index :contacts, :student_id
  end
end
