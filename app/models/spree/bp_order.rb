module Spree
  class BpOrder < Brightpearl
    attr_accessor :spree_order, :order_rows

    def initialize(order)
      super()
      @spree_order = order
      set_rows
    end

    def save
      response = Nacre::API::Order.create match_fields
      response[:id].present? ? @spree_order.update_attribute(:brightpearl_id, response[:id]) : false
      check_payment
      save_rows
      add_note
    end

    def self.create(order)
      bp_order = new(order)
      bp_order.save
      bp_order
    end

    private

    def match_fields
      hash = {
        orderTypeCode: 'SO',
        orderStatus: {
          orderStatusId: 4
        },
        currency: {
          accountingCurrencyCode: Spree::Config[:currency],
          orderCurrencyCode: Spree::Config[:currency],
          exchangeRate: 1
        },
        totalValue: {
          net: @spree_order.total.to_f
        },
        parties: {
          customer: {
            contactId: @spree_order.user.present? ? @spree_order.user.brightpearl_id : Spree::Config[:brightpearl_guest_contact_id]
          },
          delivery: {
            addressFullName: @spree_order.ship_address.full_name,
            addressLine1: @spree_order.ship_address.address1,
            addressLine2: @spree_order.ship_address.address2,
            addressLine3: @spree_order.ship_address.state_name || @spree_order.ship_address.state.try(:name),
            addressLine4: @spree_order.ship_address.country.try(:name),
            postalCode: @spree_order.ship_address.zipcode,
            countryIsoCode: @spree_order.ship_address.country.iso,
            telephone: @spree_order.ship_address.phone,
            email: @spree_order.email || spree.user.email,
          }
        }
      }

      Rails.logger.info hash

      hash
    end

    def check_payment
      return false if @spree_order.payments.completed.size > 0
      @spree_order.payments.completed.each &:save_to_brightpearl
    end

    def set_rows
      @order_rows = @spree_order.line_items.map {|line_item| Spree::BpOrderRow.new line_item}
    end

    def save_rows
      @order_rows.map &:save
    end

    def add_note
      Spree::BpOrderNote.create @spree_order if @spree_order.note
    end
  end
end
