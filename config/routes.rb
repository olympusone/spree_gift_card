Spree::Core::Engine.add_routes do
  namespace :admin do
    resources :gift_cards
  end
end