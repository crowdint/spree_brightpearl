require 'spec_helper'

describe Spree::BpProduct do
  let(:params){ { 'id' => '1010'}}

  before do
    Spree::Config[:brightpearl_email] = 'test@test.com'
    Spree::Config[:brightpearl_id] = 'crowdint'
    Spree::Config[:brightpearl_password] = 'password'
  end

  describe '#create' do
    context 'create a new product' do
      before do
        VCR.use_cassette 'bp/product_with_variants' do
          @product = described_class.create(params)
        end
      end

      it 'creates new product' do
        expect(@product).to be_valid
      end

      it 'creates new product with variants' do
        expect(@product.variants.count).to eq 1
      end
    end

    context 'create a product variant' do
      let!(:product){ create :product, name: 'Crowd product' }
      let!(:variant){ create :variant, product: product }

      before do
        VCR.use_cassette 'bp/product_with_variants' do
          @product = described_class.create(params)
        end
      end

      it 'creates a new variant in existent product' do
        expect(@product.variants.count).to eq 2
      end
    end
  end

  describe '#update' do
    let!(:product){ create :product, brightpearl_id: 1010 }
    let!(:brand){ create :taxonomy, name: 'Brand' }

    before do
      product.brand = 'Magma'

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

    it 'update product brand' do
      expect(product.brand.name).to eq 'Rails'
    end
  end

  describe '#destroy' do
    let!(:product){ create :product, brightpearl_id: 1010 }

    xit 'destroys a product' do
      expect{described_class.destroy params}.to(
        change{Spree::Product.count}.
        from(1).
        to(0)
      )
    end
  end
end
