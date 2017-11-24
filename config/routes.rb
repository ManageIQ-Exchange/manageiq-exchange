Rails.application.routes.draw do
  devise_for :users


  concern :api_base  do
    get 'api/version'
  end


  namespace :v1 do
    concerns :api_base
  end

  scope module: 'v1', path: 'latest' do
    concerns :api_base
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "v1/api#version"
end
