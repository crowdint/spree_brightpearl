require 'spec_helper'

describe Spree::BpHook do
  describe '#set_products' do
    before do
      Spree::Config[:brightpearl_email] = 'steven@crowdint.com'
      Spree::Config[:brightpearl_id] = 'crowdint'
      Spree::Config[:brightpearl_password] = 'Nagarrab8'

      VCR.use_cassette 'bp/product_webhooks' do
        subject.set_products
        @all = Nacre::API::Hooks.all
      end
    end

    it 'sets product.created webhook' do
      expect(@all.first['subscribeTo']).to eq 'product.created'
    end

    it 'sets product.modified webhook' do
      expect(@all.second['subscribeTo']).to eq 'product.modified'
    end

    # Pendind due to brightpearl bug
    # https://www.brightpearl.com/community/forums/product-support-core-platform/webhook-http-method-delete
    xit 'sets product.destroyed webhook' do
      expect(@all.third['subscribeTo']).to eq 'product.destroyed'
    end
  end
end
