Gamification::Engine.routes.draw do
  resources :games do
    resources :players
  end
end
