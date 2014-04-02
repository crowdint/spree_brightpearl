class BpProductController < AppicationController
  def create
    BpProduct.create bp_products_params
  end

  def update
    BpProduct.update bp_products_params
  end

  def destroy
    BpProduct.destroy bp_products_params
  end

  private

  def bp_products_params
    params.permit(:accountCode, :resourceType, :id, 'lifecycle-event')
  end
end
