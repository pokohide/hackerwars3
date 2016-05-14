Rails.application.routes.draw do

  get 'events/pushed'

  get 'events/pulled'

  devise_for :users, path_names: { sign_in: "login", sign_out: "logout"},
    controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root to: 'users#show'

  resources :users, only: [:index, :show] do
    member do
      get 'get_cards'
      post 'post_cards'
    end
  end

  get 'poll_event' => 'event#polled'
  post 'push_event' => 'event#pushed'

  # TwitterStreamingAPI
  namespace 'api', :module => 'api' do
    get    'tweetstreaming'       => 'tweetstreaming#index'
  end
end
