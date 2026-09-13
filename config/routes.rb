Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "grades#index"

  resources :grades, only: [ :show ] do
    resources :content_modules, only: [ :show ], path: "modules" do
      resources :topics, only: [ :show ] do
        resources :lessons, only: [ :show ]
      end
    end
  end

  resources :lessons, only: [] do
    member do
      get :reconstructed
      get :component
      get :pdf
    end
  end

  get "states", to: "state_standards#index", as: :state_standards
  get "states/:framework", to: "state_standards#show", as: :state_standard
  get "states/:framework/:code", to: "state_standards#code", as: :state_standard_code, constraints: { code: /[^\/]+/ }
end
