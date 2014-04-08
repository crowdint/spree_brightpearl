class AddBrightpearlIdToSpreeVariant < ActiveRecord::Migration
  def change
    add_column :spree_variants, :brightpearl_id, :integer
  end
end
