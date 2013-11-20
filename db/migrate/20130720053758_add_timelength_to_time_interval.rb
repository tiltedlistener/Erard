class AddTimelengthToTimeInterval < ActiveRecord::Migration
  def change
    add_column :time_intervals, :timelength, :integer
  end
end
