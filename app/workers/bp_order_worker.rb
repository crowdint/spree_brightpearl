class BpOrderWorker
  include ::Sidekiq::Worker

  def perform(order_id)
    Spree::BpOrder.create Spree::Order.find(order_id)
  end
end