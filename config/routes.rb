# frozen_string_literal: true

Rails.application.routes.draw do
  # Authentication
  resource :session, only: [ :new, :create, :destroy ]

  # Customers with nested certifications and medical records
  resources :customers do
    resources :certifications, except: [ :index ]
    resources :medical_records, except: [ :index ]
  end

  # Instructor ratings
  resources :instructor_ratings, only: [ :index, :new, :create, :edit, :update, :destroy ]

  # Courses
  resources :courses

  # Dive sites
  resources :dive_sites

  # Excursions with nested trip dives and participants
  resources :excursions do
    resources :trip_dives, only: [ :new, :create, :edit, :update, :destroy ]
    resources :trip_participants, only: [ :new, :create, :edit, :update, :destroy ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "excursions#index"
end
