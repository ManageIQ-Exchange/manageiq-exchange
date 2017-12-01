Rails.application.routes.draw do
  @api_prefix ||= Rails.application.config.api_prefix

  concern :api_base do
    get 'api/version'
    post 'github/token', to: 'github#access_token'
    get 'github/user', to: 'github#user_info'
    devise_for :users, controllers: {
        sessions: "#{@api_prefix}/users/sessions"
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

  root "#{@api_prefix}/api#version"
end
