require 'spec_helper'

describe Spree::Brightpearl::OrderRow do
  before do
    Spree::Config[:brightpearl_email] = 'steven@crowdint.com'
    Spree::Config[:brightpearl_id] = 'crowdint'
    Spree::Config[:brightpearl_password] = 'Nagarrab8'
  end

  let(:order) { create(:order_with_line_item)}
  let(:line_item) { order.line_items.first }
  let(:bp_order_row) { Spree::Brightpearl::OrderRow.new(line_item) }

  it 'creates new order row' do
    VCR.use_cassette('bp/order_row_send_to_bp') do
      Nacre::API::OrderRow.should_receive(:create).with(order.brightpearl_id, match_fields(line_item)).and_return({id:234})
    end

    VCR.use_cassette('bp/order_row_save') do
      bp_order_row.save
    end
  end

  def match_fields(line_item)
    {
      productId: line_item.variant.brightpearl_id,
      quantity: {
        magnitude: line_item.quantity
      },
      rowValue: {
        taxCode: 'T4',
        rowNet: {
          currencyCode: Spree::Config[:currency],
          value: line_item.price.to_f
        },
        rowTax: {
          currencyCode: Spree::Config[:currency],
          value: line_item.additional_tax_total.to_f
        }
      }
    }
  end
end
