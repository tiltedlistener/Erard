class AddLastInvoiceDateToStudents < ActiveRecord::Migration
  def change
    add_column :students, :last_invoice, :date
  end
end
