module Spree
  class BpHook < Brightpearl
    include Rails.application.routes.url_helpers

    def set_products
      Nacre::API::Hooks.product_resource(Spree.railtie_routes_url_helpers.bp_products_url( host: Spree::Config.site_url ))
    end
  end
end
