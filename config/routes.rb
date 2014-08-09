Spree::Core::Engine.routes.draw do

  namespace :brightpearl do
    resources :products
  end

  namespace :admin do
    resource :brightpearl, only: [:edit, :update]
  end
end
