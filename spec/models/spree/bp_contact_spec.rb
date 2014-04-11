require 'spec_helper'

describe Spree::BpContact do
  let(:user) { build :user }

  subject { described_class.new(user, 100) }

  before do
    Spree::Config[:brightpearl_email] = 'test@brightpearl.com'
    Spree::Config[:brightpearl_id] = 'mumoc'
    Spree::Config[:brightpearl_password] = 'testing123'
  end

  describe '#save' do
    before do
      VCR.use_cassette 'bp/contact' do
        subject.save
      end
    end

    it 'sets the brightpearl id on user' do
      expect(user.brightpearl_id).to eq 209
    end
  end
end

