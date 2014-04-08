module Spree
  User.class_eval do
    before_create :create_brightpearl_resources

    def create_brightpearl_resources
      bp_address = create_brightpearl_address
      create_brightpearl_contact(bp_address[:id]) if bp_address
    end

    def create_brightpearl_address
      Spree::BpPostalAddress.new.save
    end

    def create_brightpearl_contact(bp_address_id)
      Spree::BpContact.new(self, bp_address_id).save
    end

  end
end

