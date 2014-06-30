module Spree
  Payment.class_eval do
    Spree::Payment.state_machine.after_transition :to => :completed, do: :save_to_brightpearl

    def save_to_brightpearl
      BpPayment.delay.create self.id
    end
  end
end
