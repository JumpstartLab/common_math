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
end
