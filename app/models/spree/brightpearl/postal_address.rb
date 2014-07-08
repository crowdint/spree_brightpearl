module Spree
  module Brightpearl
    class PostalAddress < BaseConnection

      def save
        Nacre::API::PostalAddress.create bp_fields
      end

      private

      def bp_fields
        {
          addressLine1: 'FootCardigan Address',
          postalCode: '115-243'
        }
      end
    end
  end
end
