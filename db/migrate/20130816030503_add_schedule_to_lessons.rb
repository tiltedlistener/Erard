class AddScheduleToLessons < ActiveRecord::Migration
  def change
  	add_column :lessons, :schedule, :datetime
  end
end
