module Spree
  module Brightpearl
    class Hook < BaseConnection
      include Rails.application.routes.url_helpers

      def set_products
        Nacre::API::Hooks.product_resource(Spree.railtie_routes_url_helpers.brightpearl_products_url( host: Spree::Config.site_url ))
      end
    end
  end
end
