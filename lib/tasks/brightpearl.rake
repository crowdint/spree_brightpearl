namespace :brightpearl do
  desc "Register all necessary webhooks in Brightpearl"

  task webhooks: :environment do
    bp_hook = Spree::BpHook.new
    bp_hook.set_products
  end
end
