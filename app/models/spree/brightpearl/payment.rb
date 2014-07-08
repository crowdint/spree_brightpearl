module Spree
  module Brightpearl
    class  Payment < BaseConnection
      def initialize(payment_id)
        super()
        @spree_payment = Spree::Payment.find(payment_id)
      end

      def save
        response = Nacre::API::SalesReceipt.create match_fields
        if response[:id].present?
          @spree_payment.update_attribute(:brightpearl_id, response[:id])
          Rails.logger.info "Brightpearl Receipt (#{response[:id]}) created"
        end
      end

      def self.create(payment_id)
        bp_payment = new(payment_id)
        bp_payment.save
      end

      private

      def match_fields
        hash = {
          orderId: bp_order_id,
          received: {
            currency: Spree::Config[:currency],
            value: value
          },
          taxDate: Time.zone.today,
          bankAccountNominalCode: Spree::Config[:brightpearl_bank_account]
        }

        Rails.logger.info hash

        hash
      end

      def bp_order_id
        @spree_payment.order.brightpearl_id
      end

      def value
        @spree_payment.amount
      end
    end
  end
end
