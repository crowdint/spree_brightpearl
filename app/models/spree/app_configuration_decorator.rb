module Spree
  AppConfiguration.class_eval do
    preference :brightpearl_id,          :string
    preference :brightpearl_email,       :string
    preference :brightpearl_password,    :string
    preference :brightpearl_centre,      :string, default: 'use'
    preference :brightpearl_api_version, :string, default: '2.0.0'
  end
end
