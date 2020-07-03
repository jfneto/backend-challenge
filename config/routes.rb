# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/index'

  # WEB UI
  root to: 'home#index'
  resources :orders
  resources :batches

  get 'users', to: 'registrations#index'

  devise_for :users # , path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  # custom for list users
  # API
  namespace :api do
    namespace :v1 do
      # get 'orders', to: 'orders#index'
      get 'orders/status', to: 'orders#status'
      get 'orders/channel', to: 'orders#purchase_channel'
      post 'orders', to: 'orders#create'
      put 'orders', to: 'orders#update'

      post 'batches', to: 'batches#create'
      put 'batches/close', to: 'batches#close_orders'
      put 'batches/sent', to: 'batches#sent_orders'

      get 'reports/financial', to: 'reports#financial_report'

      post 'sign_up', to: 'registrations#create'
      get 'users', to: 'registrations#index'
      # devise_for :users, defaults: { format: :json }, as: :users
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
