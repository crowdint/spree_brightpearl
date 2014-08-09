require 'spec_helper'

describe Spree::Order do
  before do
    Spree::Config[:brightpearl_email] = 'steven@crowdint.com'
    Spree::Config[:brightpearl_id] = 'crowdint'
    Spree::Config[:brightpearl_password] = 'Nagarrab8'
  end

  let(:order) { VCR.use_cassette('bp/authorise') { create(:order_ready_to_complete) }}

  describe '#create_brightpearl_order' do
    it 'queue a new job' do
      Spree::Brightpearl::OrderWorker.should_receive(:perform_async).with(order.id)

      VCR.use_cassette('bp/order_create') do
        order.next!
      end
    end
  end
end