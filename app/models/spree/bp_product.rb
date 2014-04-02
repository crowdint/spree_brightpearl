module Spree
  class BpProduct
    attr_accessor :product

    def initialize(brightpearl_id)
      connect

      @brightpearl_id = brightpearl_id
    end

    def update
      @product.update match_fields
    end

    def match_fields
      bp_product = get_bp_product(@brightpearl_id)
      prices = get_prices(@brightpearl_id)

      {
        name:                 bp_product.sales_channels.first.product_name,
        description:          bp_product.sales_channels.first.description.text,
        sku:                  bp_product.identity.sku,
        price:                prices.price_lists.first.quantity_price.to_h.values.first,
        shipping_category_id: 1,
        brightpearl_id:       @brightpearl_id
      }
    end

    def self.create(params)
      bp_product = BpProduct.new(params['id'])
      bp_product.product = Spree::Product.new
      bp_product.update
      bp_product.product
    end

    def self.update(params)
      bp_product = BpProduct.new(params['id'])
      bp_product.product = Spree::Product.find_by brightpearl_id: params['id']
      bp_product.update
    end

    def self.destroy(params)
      Spree::Product.where(brightpearl_id: params['id']).destroy_all
    end

    private

    def connect
      Nacre::Api.new( file: Rails.root.join('config', 'brightpearl_config.yml').to_s)
    end

    def get_bp_product(brightpearl_id)
      Nacre::API::Product.find brightpearl_id
    end

    def get_prices(brightpearl_id)
      Nacre::API::Price.find brightpearl_id
    end
  end
end
