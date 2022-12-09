Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :gift_cards
  end

  namespace :api, defaults: { format: 'json' } do  
    namespace :v2 do
      namespace :storefront do
        resources :gift_cards, only: [:index, :create]
      end
    end
  end
end