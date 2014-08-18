module Spree
  Product.class_eval do
    delegate :brightpearl_id, :brightpearl_id=, to: :master

    def brand
      @brand ||= taxons.joins(:taxonomy).find_by( spree_taxonomies: {name: 'Brand'} )
    end

    def brand=(brand_name)
      taxons.delete(brand) if brand

      new_brand = Spree::Taxon.joins(:taxonomy).find_by( spree_taxonomies: {name: 'Brand'}, name: brand_name )

      if new_brand
        taxons << new_brand
      else
        taxons.new(name: brand_name, taxonomy: Spree::Taxonomy.find_by(name: 'Brand') )
      end
    end

    def set_as_backorderable
      stock_items.each do |stock_item|
        stock_item.update_attributes backorderable: true
      end
    end
  end
end
