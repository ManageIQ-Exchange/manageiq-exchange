Rails.application.routes.draw do
  @api_prefix ||= Rails.application.config.api_prefix

  concern :api_base do
    get 'api/version'
    devise_for :users, controllers: {
        sessions: "#{@api_prefix}/users/sessions"
    }
    resources :users, only: [:index, :show]
    resources :tags, only: [:index, :show]
    resources :spins

    as :user do
      resources :spins, only: [] do
        collection do
          post 'refresh'
        end
      end
    end
  end


  namespace :v1 do
    concerns :api_base
  end

  scope module: 'v1', path: '' do
    concerns :api_base
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "#{@api_prefix}/api#version"
end
