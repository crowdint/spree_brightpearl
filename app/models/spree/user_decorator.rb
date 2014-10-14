module Spree
  User.class_eval do
    before_create :create_brightpearl_resources

    def create_brightpearl_resources
      bp_address = ship_address ? create_brightpearl_address(ship_address.id) : nil
      create_brightpearl_contact(bp_address[:id]) if bp_address
    rescue Exception => e
      Rails.logger.info "Brightpearl Error: #{e.message}"
    end

    def create_brightpearl_address(address_id)
      Spree::Brightpearl::PostalAddress.new(address_id).save
    end

    def create_brightpearl_contact(bp_address_id)
      Spree::Brightpearl::Contact.new(self, bp_address_id).save
    rescue Exception => e
      Rails.logger.info "Brigthpearl Error: #{e.message}"
    end

  end
end

