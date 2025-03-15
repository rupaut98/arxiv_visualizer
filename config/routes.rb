Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Auth routes
      post '/register', to: 'auth#register'
      post '/login', to: 'auth#login'
      
      # Paper routes
      resources :papers, only: [:index, :show] do
        collection do
          get :search  # Add this line for the search endpoint
        end
      end
      get '/papers/:id/citations', to: 'papers#citations'
      
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
