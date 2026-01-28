Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      # 認証関連
      post 'registrations', to: 'registrations#create'
      post 'sessions', to: 'sessions#create'
      delete 'sessions', to: 'sessions#destroy'
      get 'me', to: 'sessions#me'

      # お土産
      resources :souvenirs do
        collection do
          get :random
        end
      end
    end
  end
end
