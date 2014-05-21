class AddBrightpearlIdToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :brightpearl_id, :integer
  end
end
