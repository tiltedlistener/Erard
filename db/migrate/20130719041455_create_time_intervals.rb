class CreateTimeIntervals < ActiveRecord::Migration
  def change
    create_table :time_intervals do |t|
      t.integer :time_code
      t.string :time_label

      t.timestamps
    end
  end
end
