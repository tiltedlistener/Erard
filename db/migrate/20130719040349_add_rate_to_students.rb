class AddRateToStudents < ActiveRecord::Migration
  def change
    add_column :students, :rate, :float
  end
end
