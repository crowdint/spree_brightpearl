class AddNoteToSpreeOrders < ActiveRecord::Migration
  def change
    unless column_exists? :spree_orders, :note
      add_column :spree_orders, :note, :text
    end
  end
end
