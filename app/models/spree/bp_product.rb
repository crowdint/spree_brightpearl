module Spree
  class BpProduct < Brightpearl
    attr_accessor :spree_product, :name, :variant

    def initialize(brightpearl_id)
      super()

      @brightpearl_id = brightpearl_id
      @name = get_bp_product.sales_channels.first.product_name
    end

    def create
      @spree_product.update match_fields

      bp_product = get_bp_product

      if bp_product.variations
        variant = Spree::Variant.create product: @spree_product
        variant.options = bp_product.variations.map{ |v| {name: v.option_name, value: v.option_value } }
      end
    end

    def update
      @spree_product.update match_fields

      bp_product = get_bp_product

      if bp_product.variations
        variant = Spree::Variant.create product: @spree_product unless variant

        variant.options = bp_product.variations.map{ |v| {name: v.option_name, value: v.option_value } }
      end
    end

    def match_fields
      bp_product = get_bp_product
      prices = get_prices(@brightpearl_id)
      brand = get_brand(bp_product.brand_id)

      {
        name:                 bp_product.sales_channels.first.product_name,
        description:          bp_product.sales_channels.first.description.text,
        sku:                  bp_product.identity.sku,
        price:                prices.price_lists.first.quantity_price.to_h.values.first,
        shipping_category_id: 1,
        brand:                brand.name,
        brightpearl_id:       @brightpearl_id
      }
    end

    def self.create(params)
      bp_product = BpProduct.new(params['id'])
      bp_product.spree_product = Spree::Product.find_or_create_by name: bp_product.name
      bp_product.update
      bp_product.spree_product
    end

    def self.update(params)
      bp_product = BpProduct.new(params['id'])
      bp_product.spree_product = Spree::Product.includes(:master).find_by(spree_variants: {brightpearl_id: params['id'] })
      bp_product.variant = Spree::Variant.find_by brightpearl_id: params['id']
      bp_product.update
    end

    def self.destroy(params)
      v = Spree::Variant.find_by(brightpearl_id: params['id'])
      v.is_master? ? v.product.destroy : v.destroy
    end

    private

    def get_bp_product
      @bp_product ||= Nacre::API::Product.find @brightpearl_id
    end

    def get_prices(brightpearl_id)
      Nacre::API::Price.find brightpearl_id
    end

    def get_brand(brand_id)
      Nacre::API::Brand.find brand_id
    end
  end
end
