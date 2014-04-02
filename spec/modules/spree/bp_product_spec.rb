require 'spec_helper'

describe Spree::BpProduct do
  let(:params){ { 'id' => '1010'}}

  describe '#create' do
    it 'creates new product' do
      VCR.use_cassette 'bp/product' do
        expect(described_class.create(params)).to be_valid
      end
    end
  end

  describe '#update' do
    let!(:product){ create :product, brightpearl_id: 1010 }

    before do
      VCR.use_cassette 'bp/product' do
        described_class.update(params)
      end

      product.reload
    end

    it 'updates product name' do
      expect(product.name).to eq 'Crowd product'
    end

    it 'updates product description' do
      expect(product.description).to eq '<p>This is the largeeeeee description!!!!!!!!</p>'
    end

    it 'updates product price' do
      expect(product.price).to eq 1000
    end
  end

  describe '#destroy' do
    let!(:product){ create :product, brightpearl_id: 1010 }

    it 'destroys a product' do
      expect{described_class.destroy params}.to(
        change{Spree::Product.count}.
        from(1).
        to(0)
      )
    end
  end
end
