class AddBrightpearlIdToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :brightpearl_id, :integer
  end
end
