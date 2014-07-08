require 'spec_helper'

describe Spree::Brightpearl::Product do
  let(:params){ { 'id' => '1010'}}

  before do
    Spree::Config[:brightpearl_email] = 'test@test.com'
    Spree::Config[:brightpearl_id] = 'crowdint'
    Spree::Config[:brightpearl_password] = 'password'
  end

  describe '#create' do
    context 'create a new product' do
      let(:product){ VCR.use_cassette('bp/product_with_variants'){ @product = described_class.create(params) } }

      it 'creates new product' do
        expect(product).to be_valid
      end

      it 'creates new product with variants' do
        expect(product.variants.count).to eq 1
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
      expect(product.price).to eq BigDecimal.new(1000)
    end

    it 'updates product cost_price' do
      expect(product.cost_price).to eq BigDecimal.new(100)
    end

    it 'update product brand' do
      expect(product.brand.name).to eq 'Rails'
    end
  end

  describe '#destroy' do
    context 'a product' do
      let!(:product){ create :product, brightpearl_id: 1010 }

      it 'destroys a product' do
        expect{described_class.destroy params}.to(
          change{Spree::Product.count}.
          from(1).
          to(0)
        )
      end
    end

    context 'a variant' do
      let!(:variant){ create :product, brightpearl_id: 1010 }

      it 'destroys a product' do
        expect{described_class.destroy params}.to(
          change{Spree::Variant.count}.
          from(1).
          to(0)
        )
      end
    end
  end

  describe '#sync_stock' do
    let!(:product){ create :product, brightpearl_id: 1010 }

    before do
      VCR.use_cassette 'bp/product_stock' do
        described_class.sync_stock(params)
      end
    end

    it 'sets count on hand' do
      expect(product.total_on_hand).to eq 80
    end
  end
end
