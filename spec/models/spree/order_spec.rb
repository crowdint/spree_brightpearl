require 'spec_helper'

describe Spree::BpOrder do
  before do
    Spree::Config[:brightpearl_email] = 'steven@crowdint.com'
    Spree::Config[:brightpearl_id] = 'crowdint'
    Spree::Config[:brightpearl_password] = 'Nagarrab8'
  end

  let(:order) { VCR.use_cassette('bp/authorise') { create(:order_ready_to_complete) }}

  it 'queue a new job' do
    BpOrderWorker.should_receive(:perform_async).with(order.id)
    
    VCR.use_cassette('bp/order_create') do
      order.next!
    end
  end
end