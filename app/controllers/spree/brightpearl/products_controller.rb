module Spree
  module Brightpearl
    class ProductsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        Spree::Brightpearl::Product.create bp_products_params
        render nothing: true
      end

      def update
        if params['full-event'] == 'product.modified.on-hand-modified'
          Spree::Brightpearl::Product.sync_stock(bp_products_params)
        else
          Spree::Brightpearl::Product.update bp_products_params
        end

        render nothing: true
      end

      def destroy
        Spree::Brightpearl::Product.destroy bp_products_params
        render nothing: true
      end

      private

      def bp_products_params
        params.permit(:accountCode, :resourceType, :id, 'lifecycle-event', 'full-event')
      end
    end
  end
end
