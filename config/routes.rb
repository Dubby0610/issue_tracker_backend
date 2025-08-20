Rails.application.routes.draw do
  # Health check endpoint
  get "health", to: "application#health"
  
  # Database info endpoint
  get "db-info", to: "application#db_info"
  
  # API routes
  resources :projects do
    resources :issues do
      resources :comments, except: [:show]
    end
  end

  resources :users
  
  # Additional comment routes (for direct access)
  resources :comments, only: [:update, :destroy]
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
