class AddBrightpearlIdToSpreePayments < ActiveRecord::Migration
  def change
    add_column :spree_payments, :brightpearl_id, :integer
  end
end
