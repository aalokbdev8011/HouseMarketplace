# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  resources :properties do
    collection do
      get :filter_properties
    end
  end

  resources :favorites, only: %i[index create destroy]
end
