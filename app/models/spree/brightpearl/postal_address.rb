module Spree
  module Brightpearl
    class PostalAddress < BaseConnection

      def initialize(address_id)
        super()
        @spree_address = Spree::Address.find(address_id) if address_id
      end

      def save
        Nacre::API::PostalAddress.create bp_fields
      end

      private

      def bp_fields
        {
          addressLine1: @spree_address.try(:address1) || 'FootCardigan Address',
          addressLine3: @spree_address.try(:city) || 'FootCardigan City',
          addressLine4: state.try(:name) || 'FootCardigan State',
          postalCode: @spree_address.try(:zipcode) || '115-243',
          countryIsoCode: country.try(:iso3) || ''
        }
      end

      def country
        @country ||= @spree_address.country if @spree_address
      end

      def state
        @state ||= @spree_address.state if @spree_address
      end
    end
  end
end
