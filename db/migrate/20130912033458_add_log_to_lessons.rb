class AddLogToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :log, :text
  end
end
