module Spree
  class BpOrderNote < Brightpearl
    attr_accessor :order

    def initialize(order)
      super()
      @order = order
    end

    def save
      Nacre::API::OrderNote.create @order.brightpearl_id, match_fields
    end

    def self.create(order)
      bp_note = new(order)
      bp_note.save
    end

    private
    def match_fields
      {
        text: @order.note
      }
    end
  end
end
