require 'spec_helper'

describe Spree::Brightpearl::PostalAddress do

  before do
    Spree::Config[:brightpearl_email] = 'mumo.crls@gmail.com'
    Spree::Config[:brightpearl_id] = 'mumoc'
    Spree::Config[:brightpearl_password] = '220502Camubrightpearl'
  end

  describe '#save' do
    let(:bp_address) { described_class.new nil }

    let(:response) do
      VCR.use_cassette 'bp/postal_address' do
        bp_address.save
      end
    end

    it 'sets the brightpearl id on user' do
      expect(response).to eq({ id: 155 })
    end
  end
end

