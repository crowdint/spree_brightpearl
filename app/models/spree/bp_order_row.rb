module Spree
  class BpOrderRow < Brightpearl

    def initialize(line_item)
      super()
      @line_item = line_item
    end

    def save
      Nacre::API::OrderRow.create @line_item.order.brightpearl_id, match_fields
    end

  private
    def match_fields
      {
        productId: @line_item.variant.brightpearl_id,
        quantity: {
          magnitude: @line_item.quantity
        },
        rowValue: {
          taxCode: 'T4',
          rowNet: {
            currencyCode: Spree::Config[:currency],
            value: @line_item.price.to_f
          },
          rowTax: {
            currencyCode: Spree::Config[:currency],
            value: @line_item.additional_tax_total.to_f
          }
        }
      }
    end
  end
end
