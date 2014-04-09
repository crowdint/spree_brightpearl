module Spree
  class BpHook < Brightpearl
    def set_products
      Nacre::API::Hooks.product_resource('http://' + Spree::Config.site_url + '/bp_products')
    end
  end
end
