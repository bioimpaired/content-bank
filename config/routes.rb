Rails.application.routes.draw do
  root :to => "ads#index"

  resources :ads do 
    member do
      patch :sort
    end
  end

  resources :countries
  resources :brands
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
