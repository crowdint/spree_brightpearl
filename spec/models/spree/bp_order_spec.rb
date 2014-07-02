require 'spec_helper'

describe Spree::BpOrder do
  before do
    Spree::Config[:brightpearl_email] = 'steven@crowdint.com'
    Spree::Config[:brightpearl_id] = 'crowdint'
    Spree::Config[:brightpearl_password] = 'Nagarrab8'
  end

  let(:order) { VCR.use_cassette('bp/authorise') { create(:order_ready_to_complete) }}
  

  describe "initialize" do
    let(:bp_order) { VCR.use_cassette('bp/order_new') { Spree::BpOrder.new order }}
    
    it "create the BpOrderRow" do
      bp_order.order_rows.size.should == order.line_items.size
    end
  end

  describe "self.create" do
    let(:bp_order) { double("Spree::BpOrder") }

    it "create new product" do
      Spree::BpOrder.should_receive(:new).with(order).and_return(bp_order)
      bp_order.should_receive(:save)
      
      Spree::BpOrder.create order
    end
  end
  
  describe "save" do
    let(:bp_order) { VCR.use_cassette('bp/order_save') { Spree::BpOrder.new order }}
    
    it "send to brightpearl" do
      Nacre::API::Order.should_receive(:create).with(match_fields(order)).and_return({id: 123})
      
      VCR.use_cassette('bp/order_row_create') {
        bp_order.save
      }
    end
  end
  
  def match_fields(order)
    {
      orderTypeCode: 'SO',
      reference: order.number,
      orderStatus: {
        orderStatusId: 4
      },
      currency: {
        accountingCurrencyCode: Spree::Config[:currency],
        orderCurrencyCode: Spree::Config[:currency],
        exchangeRate: 1
      },
      totalValue: {
        net: order.total.to_f
      },
      parties: {
        customer: {
          contactId: order.user.present? ? order.user.brightpearl_id : Spree::Config[:brightpearl_guest_contact_id]
        },
        delivery: {
          addressFullName: order.ship_address.full_name,
          addressLine1: order.ship_address.address1,
          addressLine2: order.ship_address.address2,
          addressLine3: order.ship_address.state_name || order.ship_address.state.try(:name),
          addressLine4: order.ship_address.country.try(:name),
          postalCode: order.ship_address.zipcode,
          countryIsoCode: order.ship_address.country.iso,
          telephone: order.ship_address.phone,
          email: order.email || spree.user.email,
        }
      }
    }
  end
end
