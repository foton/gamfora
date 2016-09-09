Gamfora::Engine.routes.draw do
  resources :games do
    resources :players, except: [:edit, :update] 
    resources :actions
  end
end
