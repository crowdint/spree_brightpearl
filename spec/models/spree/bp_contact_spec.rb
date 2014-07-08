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

  describe '#bp_fields' do
    before do
      allow(user).to receive(:first_name) { "Les" }
      allow(user).to receive(:last_name)  { "Claypool" }
      user.email = "test@example.com"
    end

    it 'returns the hash that is sent to Brightpearl' do
      VCR.use_cassette 'bp/contact' do
        expect(subject.bp_fields).to eq({
          :salutation     => "Mr.",
          :firstName      => "Les",
          :lastName       => "Claypool",
          :postAddressIds => {:DEF=>100, :BIL=>100, :DEL=>100},
          :communication  => {
              :emails=>{:PRI=>{:email=>"test@example.com"}}}, :financialDetails=>{:accountBalance=>0}
          })
      end
    end
  end
end

