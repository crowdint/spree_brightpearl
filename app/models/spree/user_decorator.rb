module Spree
  User.class_eval do
    before_create :create_brightpearl_resources

    def create_brightpearl_resources
      begin
        bp_address = create_brightpearl_address
        create_brightpearl_contact(bp_address[:id]) if bp_address
      rescue Exception => e
        Rails.logger.info "Brifhtpearl Error: #{e.message}"
      end
    end

    def create_brightpearl_address
      binding.pry
      Spree::BpPostalAddress.new.save
    end

    def create_brightpearl_contact(bp_address_id)
      begin
        Spree::BpContact.new(self, bp_address_id).save
      rescue Exception => e
        Rails.logger.info "Brigthpearl Error: #{e.message}"
      end
    end

  end
end

