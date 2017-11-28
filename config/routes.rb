Rails.application.routes.draw do
  VERSION = "v1"
  devise_for :users


  concern :api_base do
    get 'api/version'
    post 'github/token', to: 'github#access_token'
    get 'github/user', to: 'github#user_info'
  end


  namespace :v1 do
    concerns :api_base
  end

  scope module: 'v1', path: 'latest' do
    concerns :api_base
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "#{VERSION}/api#version"
end
