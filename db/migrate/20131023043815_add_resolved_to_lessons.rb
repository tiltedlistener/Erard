class AddResolvedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :resolved, :boolean
  end
end
