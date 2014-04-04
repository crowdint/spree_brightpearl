Spree::Core::Engine.routes.draw do
  Spree::Core::Engine.routes.draw do
    resources :bp_products

    namespace :admin do
      resource :brightpearl, only: [:edit, :update]
    end
  end
end
