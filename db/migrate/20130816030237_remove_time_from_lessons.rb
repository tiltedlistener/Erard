class RemoveTimeFromLessons < ActiveRecord::Migration
	def change
		remove_column :lessons, :time
	end
end
