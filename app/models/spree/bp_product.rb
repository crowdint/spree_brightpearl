module Spree
  class BpProduct < Brightpearl
    attr_accessor :spree_product, :name, :variant

    def initialize(brightpearl_id, name = nil)
      super()

      @brightpearl_id = brightpearl_id
      @name = name || get_bp_product.sales_channels.first.product_name
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
      #bp_product.add_taxon
      bp_product.spree_product
    end

    def self.update(params)
      bp_product = new(params['id'])
      bp_product.variant = Spree::Variant.includes(:product).find_or_create_by brightpearl_id: params['id']
      bp_product.spree_product = bp_product.variant.product
      bp_product.add_taxon
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

    def self.generate(gender, recurring, wrap_type, limit = nil, price = 11, wrap_cost = 2)
      name = Spree::BpProduct.create_name(gender, recurring, wrap_type, limit)
      product = new(nil, name)
      response = product.create_bp_product(name)
      total_price = product.calculate_price(price, wrap_cost, wrap_type, limit, recurring)
      Spree::BpProduct.delay.update_created_product(response[:id], recurring, limit, total_price)
    end

    def self.update_created_product(brightpearl_id, recurring, limit, total_price)
      bp_product = new(brightpearl_id)
      variant = Spree::Variant.find_by brightpearl_id: brightpearl_id
      raise 'Product do not created yet' unless variant

      bp_product.spree_product = variant.product
      response = Spree::BpProduct.update_product_price(brightpearl_id, total_price)
      bp_product.update_product(recurring, limit, total_price) if response.status == 200
    end

    def update_product(recurring, limit, total_price)
      spree_product.update_attributes price: total_price, recurring: recurring, limit: limit, type: 'Spree::SubscriptionProduct'
    end

    def create_bp_product(name)
      product_fields = {
        brandId: 74,
        salesChannels: [{
          salesChannelName: 'Brightpearl',
          productName: name,
          categories: [
              { categoryCode: '276' }
          ]
        }]
      }
      Nacre::API::Product.create(product_fields)
    end

    def self.update_product_price(brightpearl_id, price)
      product_price_fields = {
        priceLists: [{
           priceListId: 1,
           quantityPrice: {
               1 => price
           }
       }]
      }
      Nacre::API::Price.update(product_price_fields, brightpearl_id)
    end

    def self.create_name(gender, recurring, wrap_type, limit)
      name = "Socks for #{ gender }"
      name += recurring ? ' - Pay monthly' : ' - Pay once'
      name += " - Wrap #{ wrap_type }" unless wrap_type == 'none'
      name += " - By #{ limit } months" if limit || limit.present?
      name
    end

    def calculate_price(price, wrap_cost, wrap_type, limit, recurring)
      total_price =  price
      total_price += wrap_cost if wrap_type == 'every month'
      unless recurring
        total_price *= limit
        total_price += wrap_cost if wrap_type == 'first month'
      end
      total_price
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
