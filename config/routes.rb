Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Auth routes
      post '/register', to: 'auth#register'
      post '/login', to: 'auth#login'
      get '/auth/status', to: 'auth_status#show'
      get '/api/v1/bookmarks/auth_check', to: 'api/v1/bookmarks#auth_check'
      get '/api/v1/debug-auth', to: 'api/v1/bookmarks#debug_auth'


      # Paper routes
      resources :papers, only: [:index, :show] do
        collection do
          get :search  # Add this line for the search endpoint
        end
      end
      
      # Bookmark routes
      resources :bookmarks, only: [:index, :create, :update, :destroy]
    end
  end
  
  # Route all other requests to the Vue.js frontend
  get '*path', to: 'application#index', constraints: lambda { |req|
    req.path.exclude? 'rails/active_storage' and req.path.exclude? 'api/'
  }
  
  root 'application#index'
end
