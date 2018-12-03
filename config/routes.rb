# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get 'home/index'
  root to: 'home#index'

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords'
  }

  resources :companies, only: [] do
    resources :customers, only: [:index]

    collection do
      get  :upload
      post :bulk_upload
    end
  end

  resources :customers, only: [:index]
end
