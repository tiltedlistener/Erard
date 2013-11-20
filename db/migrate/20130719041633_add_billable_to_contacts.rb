class AddBillableToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :billable, :boolean
  end
end
