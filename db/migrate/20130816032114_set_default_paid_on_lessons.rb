class SetDefaultPaidOnLessons < ActiveRecord::Migration
  def change
    change_column :lessons, :paid, :boolean, :default => false
  end
end
