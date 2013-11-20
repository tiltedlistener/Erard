class RemoveDateFromLessons < ActiveRecord::Migration
	def change
		remove_column :lessons, :date
	end
end
