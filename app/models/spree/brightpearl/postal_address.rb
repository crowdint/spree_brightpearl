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
          postalCode: @spree_address.try(:zipcode) || '115-243'
        }
      end
    end
  end
end
