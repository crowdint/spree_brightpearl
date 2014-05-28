module Spree
  class BpProductsController < ApplicationController
    def create
      Spree::BpProduct.create bp_products_params
    end

    def update
      if params['full-event'] == 'product.modified.on-hand-modified'
        Spree::BpProduct.sync_stock(bp_products_params)
      else
        Spree::BpProduct.update bp_products_params
      end
    end

    def destroy
      Spree::BpProduct.destroy bp_products_params
    end

    private

    def bp_products_params
      params.permit(:accountCode, :resourceType, :id, 'lifecycle-event', 'full-event')
    end
  end
end
