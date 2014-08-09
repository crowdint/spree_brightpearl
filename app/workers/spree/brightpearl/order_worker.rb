module Spree::Brightpearl
  class OrderWorker
    include ::Sidekiq::Worker

    def perform(order_id)
      Spree::Brightpearl::Order.create Spree::Order.find(order_id)
    end
  end
end
