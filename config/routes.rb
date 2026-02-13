# frozen_string_literal: true

Rails.application.routes.draw do
  # Authentication
  resource :session, only: [ :new, :create, :destroy ]

  # Customers with nested certifications, medical records, equipment profile, and tanks
  resources :customers do
    resources :certifications, except: [ :index ]
    resources :medical_records, except: [ :index ]
    resource :equipment_profile, only: [ :show, :new, :create, :edit, :update, :destroy ]
    resources :customer_tanks
  end

  # Staff users
  resources :users

  # Instructor ratings
  resources :instructor_ratings, only: [ :index, :new, :create, :edit, :update, :destroy ]

  # Courses with nested offerings and sessions
  resources :courses do
    resources :course_offerings, except: [ :index ] do
      resources :class_sessions, except: [ :index ] do
        resource :session_attendances, only: [] do
          patch :batch_update, on: :collection
        end
      end
      resources :enrollments, only: [ :new, :create, :edit, :update, :destroy ] do
        member { post :complete }
      end
    end
  end

  # Equipment items with nested service records
  resources :equipment_items do
    resources :service_records, except: [ :index ]
  end

  # Dive sites
  resources :dive_sites

  # Excursions with nested trip dives and participants
  resources :excursions do
    resources :trip_dives, only: [ :new, :create, :edit, :update, :destroy ]
    resources :trip_participants, only: [ :new, :create, :edit, :update, :destroy ]
  end

  # API v1
  namespace :api do
    namespace :v1 do
      resource :authentication, only: [ :create ]
      resources :api_tokens, only: [ :index, :create, :destroy ]

      concern :api_resource do
        # Excludes new/edit actions (HTML-only)
      end

      resources :customers, except: [ :new, :edit ] do
        resources :certifications, except: [ :new, :edit ]
        resources :medical_records, except: [ :new, :edit ]
        resource :equipment_profile, only: [ :show, :create, :update, :destroy ]
        resources :customer_tanks, except: [ :new, :edit ]
      end

      resources :equipment_items, except: [ :new, :edit ] do
        resources :service_records, except: [ :new, :edit ]
      end

      resources :users, except: [ :new, :edit ]

      resources :instructor_ratings, only: [ :index, :show, :create, :update, :destroy ]

      resources :courses, except: [ :new, :edit ] do
        resources :course_offerings, except: [ :new, :edit ] do
          resources :class_sessions, except: [ :new, :edit ] do
            resource :session_attendances, only: [] do
              patch :batch_update, on: :collection
            end
          end
          resources :enrollments, except: [ :new, :edit ] do
            member { post :complete }
          end
        end
      end

      resources :dive_sites, except: [ :new, :edit ]

      resources :excursions, except: [ :new, :edit ] do
        resources :trip_dives, except: [ :new, :edit ]
        resources :trip_participants, except: [ :new, :edit ]
      end
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Dashboard
  resource :dashboard, only: [ :show ], controller: "dashboard"

  # Root path
  root "dashboard#show"
end
