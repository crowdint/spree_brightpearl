module Spree::Brightpearl
  class OrderWorker
    include ::Sidekiq::Worker

    def perform(order_id)
      order = Spree::Order.find(order_id)
      Spree::Brightpearl::Order.create order
    end
  end
end
