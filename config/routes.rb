Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "up" => "rails/health#show", as: :rails_health_check
  # Health check endpoints
  get "/health/liveness", to: "health#liveness"
  get "/health/readiness", to: "health#readiness"

  namespace :api do
    namespace :v1 do
      resources :participants, only: [ :index, :create, :show, :update ] do
        collection do
          get "search"
        end
      end
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
