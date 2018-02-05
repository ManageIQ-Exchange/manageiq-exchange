Rails.application.routes.draw do
  @api_prefix ||= Rails.application.config.api_prefix

  concern :api_base do
    get 'api/version'
    devise_for :users, controllers: {
        sessions: "#{@api_prefix}/users/sessions"
    }
    resources :users, only: [:index, :show] do
      resources :spins, only: [:index, :show, :destroy]
    end

    # namespace :admin do
    #   resources :users, only: [:index, :show] do
    #     resources :spins, only: [:index, :show, :destroy]
    #     resources :spin_candidates, only: [:index, :show] do
    #       collection do
    #         post 'refresh'
    #       end
    #       post 'publish', to: 'spin_candidates#publish'
    #     end
    #   end
    # end

    resources :spin_candidates, only: [:index, :show] do # on the user resources
      collection do
        post 'refresh'
      end
      post 'publish', to: 'spin_candidates#publish'
    end
    resources :tags,  only: [:index, :show]
    resources :spins, only: [:index, :show]
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
