Rails.application.routes.draw do

  devise_for :users, path_names: { sign_in: "login", sign_out: "logout"},
    controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root to: 'users#show'

  resources :users, only: [:index, :show] do
    member do
      get 'get_cards'
      post 'post_cards'
    end
  end

  # API
  namespace 'api', :module => 'api' do
    get    'tweet'       => 'tweet#index'
    get    'trend'       => 'trend#index'
  end
end
