require 'spec_helper'

describe Spree::BpPayment do
  let(:payment) { create :payment }

  before do
    Spree::Config[:brightpearl_email] = 'test@test.com'
    Spree::Config[:brightpearl_id] = 'crowdint'
    Spree::Config[:brightpearl_password] = 'password'
    Spree::Config[:brightpearl_bank_account] = '1000'

    payment.order.update_attribute :brightpearl_id, 86
  end

  describe '#save' do
    let(:subject) { Spree::BpPayment.new(payment.id) }

    before do
      VCR.use_cassette('bp/payment') do
        subject.save
      end
      payment.reload
    end

    it 'sends payment to brightpearl' do
      expect(payment.brightpearl_id).to be_present
    end
  end
end
