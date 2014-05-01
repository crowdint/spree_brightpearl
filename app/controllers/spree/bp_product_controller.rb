class BpProductController < ApplicationController
  def create
    BpProduct.create bp_products_params
  end

  def update
    if params['full-event'] == 'product.modified.on-hand-modified'
      BpProduct.sync_stock(bp_products_params)
    else
      BpProduct.update bp_products_params
    end
  end

  def destroy
    BpProduct.destroy bp_products_params
  end

  private

  def bp_products_params
    params.permit(:accountCode, :resourceType, :id, 'lifecycle-event', 'full-event')
  end
end
