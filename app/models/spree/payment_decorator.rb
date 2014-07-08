module Spree
  Payment.class_eval do
    Spree::Payment.state_machine.after_transition :to => :completed, do: :save_to_brightpearl

    def save_to_brightpearl
      Brightpearl::Payment.delay.create(id) if order.brightpearl_id
    end
  end
end
