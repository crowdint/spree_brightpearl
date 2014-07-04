module Spree
  class BpContact < Brightpearl
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
      hash = {
        salutation: 'Mr.',
        firstName: @user.first_name,
        lastName: @user.first_name,
        postAddressIds: {
          DEF: bp_address_id,
          BIL: bp_address_id,
          DEL: bp_address_id
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

