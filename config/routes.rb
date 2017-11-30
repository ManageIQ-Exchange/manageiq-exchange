Rails.application.routes.draw do
  PREFIX = "v1".freeze



  concern :api_base do
    get 'api/version'
    post 'github/token', to: 'github#access_token'
    get 'github/user', to: 'github#user_info'
    devise_for :users, controllers: {
        sessions: "#{PREFIX}/users/sessions"
    }
    resources :users, only: [:index]
    resources :tags, only: [:index, :show]
  end


  namespace :v1 do
    concerns :api_base
  end

  scope module: 'v1', path: 'latest' do
    concerns :api_base
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "#{PREFIX}/api#version"
end
