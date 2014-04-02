class AddBrightpearlidToSpreeProduct < ActiveRecord::Migration
  def change
    add_column :spree_products, :brightpearl_id, :integer
  end
end
