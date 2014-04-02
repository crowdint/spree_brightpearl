module Spree
  Product.class_eval do
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
  end
end
