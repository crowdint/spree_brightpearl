module Spree
  module Brightpearl
    class Product < BaseConnection
      attr_accessor :spree_product, :name, :variant, :product_type_id

      def initialize(brightpearl_id, name = nil)
        super()

        @brightpearl_id = brightpearl_id
        product = get_bp_product
        @name = name || product.sales_channels.first.product_name
        @product_type_id = product.product_type_id
      end

      def update
        @spree_product.update match_fields

        bp_product = get_bp_product

        if bp_product.variations
          variant = Spree::Variant.create product: @spree_product unless variant
          variant.options = bp_product.variations.map{ |v| {name: v.option_name, value: v.option_value } }
        end
      end

      def sync_stock
        stock = get_availability

        variant.sync_stock(stock.on_hand)
      end

      def match_fields
        bp_product = get_bp_product
        prices = get_prices(@brightpearl_id)
        brand = get_brand(bp_product.brand_id)

        hash = {
          name:                 bp_product.sales_channels.first.product_name,
          description:          bp_product.sales_channels.first.description.text,
          sku:                  bp_product.identity.sku,
          cost_price:           prices.price_lists.first.quantity_price.to_h.values.first || 0,
          price:                prices.price_lists.last.quantity_price.to_h.values.first || 0,
          shipping_category_id: 1,
          brand:                brand.name,
          brightpearl_id:       @brightpearl_id
        }

        Rails.logger.info hash

        hash
      end

      def taxonomy_name
        'Categories'
      end

      def taxon_name
        'Brightpearl'
      end

      def add_taxon
        if @spree_product.taxons.where(permalink: [taxonomy_name.to_url, taxon_name.to_url].join('/')).count == 0
          taxonomy = Spree::Taxonomy.find_or_create_by name: taxonomy_name
          taxon = Spree::Taxon.find_or_create_by name: taxon_name, taxonomy: taxonomy, parent_id: taxonomy.root.id
          @spree_product.taxons << taxon
        end
      end

      def self.create(params)
        bp_product = new(params['id'])
        bp_product.spree_product = Spree::Product.find_or_create_by name: bp_product.name
        bp_product.update
        bp_product.spree_product.set_as_backorderable
        bp_product.spree_product.set_availble_on_today
        bp_product.add_taxon
        bp_product.spree_product
      end

      def self.update(params)
        bp_product = new(params['id'])
        bp_product.variant = Spree::Variant.includes(:product).find_or_create_by brightpearl_id: params['id']
        bp_product.spree_product = bp_product.variant.product
        bp_product.update
      end

      def self.destroy(params)
        v = Spree::Variant.find_by(brightpearl_id: params['id'])
        v.is_master? ? v.product.destroy : v.destroy
      end

      def self.sync_stock(params)
        bp_product = new(params['id'])
        bp_product.variant = Spree::Variant.find_by brightpearl_id: params['id']
        bp_product.sync_stock
      end

      private

      def create_default_bp_brand
        Nacre::API::Brand.create( { name: 'default' } )
      end

      def get_bp_product
        @bp_product ||= Nacre::API::Product.find @brightpearl_id
      end

      def get_prices(brightpearl_id)
        Nacre::API::Price.find brightpearl_id
      end

      def get_brand(brand_id)
        Nacre::API::Brand.find brand_id
      end

      def get_availability
        Nacre::API::ProductAvailability.find @brightpearl_id
      end
    end
  end
end
