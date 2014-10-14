module Spree
  module Brightpearl
    class Contact < BaseConnection
      attr_accessor :user, :bp_address_id

      def initialize(user, bp_address_id)
        super()
        @user = user
        @bp_address_id = bp_address_id
      end

      def save
        response = Nacre::API::Contact.create bp_fields
        user.brightpearl_id = response[:id]
      end

      def bp_fields
        # TODO: Since Spree does not include username functionality we're
        # doing a default here. Make sure we fix it in a better manner.
        hash = {
          salutation: 'Mr.',
          firstName: @user.try(:first_name) || 'First Name',
          lastName: @user.try(:last_name) || 'Last Name',
          postAddressIds: {
            DEF: bp_address_id,
            BIL: bp_address_id,
            DEL: bp_address_id
          },
          organisation: {
            name: user.id
          },
          communication: {
            emails: {
              PRI: { email: user.email }
            }
          },
          financialDetails:{
            accountBalance: 0
          }
        }

        Rails.logger.info hash

        hash
      end
    end
  end
end

