class AddInvoicePeriodToStudents < ActiveRecord::Migration
  def change
    add_column :students, :invoice_period, :integer
  end
end
