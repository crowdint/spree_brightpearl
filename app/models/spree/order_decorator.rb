module Spree  
  Order.class_eval do
    Spree::Order.state_machine.after_transition :to => :complete, :do => :create_brightpearl_order
    
    def create_brightpearl_order
      Brightpearl::OrderWorker.perform_async self.id
    end
  end
end