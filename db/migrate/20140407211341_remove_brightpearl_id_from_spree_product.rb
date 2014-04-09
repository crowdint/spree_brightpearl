class RemoveBrightpearlIdFromSpreeProduct < ActiveRecord::Migration
  def change
    remove_column :spree_products, :brightpearl_id, :integer
  end
end
