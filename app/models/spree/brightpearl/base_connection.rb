module Spree
  module Brightpearl
    class BaseConnection
      def initialize
        connect
      end

      def connect
        Nacre::Api.new(
          email:                Spree::Config[:brightpearl_email],
          id:                   Spree::Config[:brightpearl_id],
          password:             Spree::Config[:brightpearl_password],
          distribution_centre:  Spree::Config[:brightpearl_centre],
          api_version:          Spree::Config[:brightpearl_api_version]
        )
      end
    end
  end
end
