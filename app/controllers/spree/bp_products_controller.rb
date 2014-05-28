module Spree
  class BpProductsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      Spree::BpProduct.create bp_products_params
      render nothing: true
    end

    def update
      if params['full-event'] == 'product.modified.on-hand-modified'
        Spree::BpProduct.sync_stock(bp_products_params)
      else
        Spree::BpProduct.update bp_products_params
      end

      render nothing: true
    end

    def destroy
      Spree::BpProduct.destroy bp_products_params
      render nothing: true
    end

    private

    def bp_products_params
      params.permit(:accountCode, :resourceType, :id, 'lifecycle-event', 'full-event')
    end
  end
end
