module Spree
  class BpOrderNote < Brightpearl
    attr_accessor :order

    def initilize(order)
      super()
      @order = order
    end

    def save
      Nacre::API::OrderRow.create @order.brightpearl_id, match_fields
    end

    def create(order)
      bp_note = new(order)
      bp_save
    end

    private
    def match_fieds
      {
        text: @order.note
      }
    end
  end
end
