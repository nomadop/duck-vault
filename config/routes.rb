Rails.application.routes.draw do
  post 'authentication/login'
  resources :accounts do
    collection do
      get 'section'
    end

    member do
      post 'inactive'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
