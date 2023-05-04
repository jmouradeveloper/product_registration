Rails.application.routes.draw do
  resources :products, only: %i[ index create show ] do
    put '/deactivate', to: 'products#deactivate'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
