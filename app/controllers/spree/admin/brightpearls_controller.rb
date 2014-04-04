module Spree
  module Admin
    class BrightpearlsController < Spree::Admin::BaseController
      def edit
        @preferences = [
          :brightpearl_id,
          :brightpearl_email,
          :brightpearl_password,
          :brightpearl_centre,
          :brightpearl_api_version
        ]
      end

      def update
        brightpearl_params.each do |name, value|
          Spree::Config[name] = value
        end

        flash[:sucess] = Spree.t(:successfully_updated, resource: Spree.t(:brightpearl_settings) )

        redirect_to edit_admin_brightpearl_path
      end

      private

      def brightpearl_params
        params.permit :brightpearl_id,:brightpearl_email, :brightpearl_password, :brightpearl_centre, :brightpearl_api_version
      end
    end
  end
end
