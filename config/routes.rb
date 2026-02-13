# frozen_string_literal: true

Rails.application.routes.draw do
  # Onboarding: shop registration (platform-level, no tenant/auth)
  scope module: :onboarding do
    get  "start", to: "registrations#new", as: :onboarding_start
    post "start", to: "registrations#create"
  end

  # Invitation acceptance (tenant-resolved, no auth)
  scope module: :onboarding do
    get  "invitations/:token/accept", to: "invitation_acceptances#new", as: :accept_invitation
    post "invitations/:token/accept", to: "invitation_acceptances#create"
  end

  # Onboarding management (authenticated)
  delete "onboarding/demo_data", to: "onboarding/demo_data#destroy", as: :clear_demo_data
  patch  "onboarding/dismiss", to: "onboarding/dismissals#update", as: :dismiss_onboarding

  # Staff invitation management (authenticated, owner-only)
  resources :user_invitations, only: [ :new, :create, :destroy ], path: "invitations"

  # Authentication
  resource :session, only: [ :new, :create, :destroy ]

  # Customers with nested certifications, medical records, equipment profile, and tanks
  resources :customers do
    resources :certifications, except: [ :index ]
    resources :medical_records, except: [ :index ]
    resource :equipment_profile, only: [ :show, :new, :create, :edit, :update, :destroy ]
    resources :customer_tanks
  end

  # Org-wide indexes
  resources :medical_records, only: [ :index ]
  resources :customer_tanks, only: [ :index ], controller: "all_customer_tanks", as: :all_customer_tanks

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

  # Checklists
  resources :checklist_templates do
    resources :checklist_items, except: [ :index, :show ]
  end

  resources :checklist_runs, only: [ :index, :show ] do
    resources :checklist_responses, only: [ :update ]
    member do
      post :complete
      post :abandon
    end
  end

  # Dive sites
  resources :dive_sites

  # Excursions with nested trip dives, participants, and checklists
  resources :excursions do
    resources :trip_dives, only: [ :new, :create, :edit, :update, :destroy ]
    resources :trip_participants, only: [ :new, :create, :edit, :update, :destroy ]
    resources :checklist_runs, only: [ :new, :create ], controller: "excursion_checklist_runs"
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

      resources :checklist_templates, except: [ :new, :edit ] do
        resources :checklist_items, except: [ :new, :edit ]
      end

      resources :checklist_runs, only: [ :index, :show, :create, :destroy ] do
        resources :checklist_responses, only: [ :index, :show, :update ]
        member do
          post :complete
          post :abandon
        end
      end

      resources :dive_sites, except: [ :new, :edit ]

      resources :excursions, except: [ :new, :edit ] do
        resources :trip_dives, except: [ :new, :edit ]
        resources :trip_participants, except: [ :new, :edit ]
      end
    end
  end

  # Public-facing catalog and customer auth (no staff auth required)
  scope module: :public do
    # Catalog
    scope "/catalog", as: :catalog do
      scope module: :catalog do
        resources :excursions, only: [ :index, :show ]
        resources :courses, only: [ :index, :show ]
        resources :dive_sites, only: [ :index, :show ], path: "dive-sites"
      end
    end

    # Customer authentication
    get "signup", to: "registrations#new", as: :public_signup
    post "signup", to: "registrations#create"
    get "login", to: "sessions#new", as: :public_login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :public_logout
    get "confirm-email", to: "confirmations#show", as: :public_confirm_email
    get "confirmation-pending", to: "confirmations#pending", as: :public_confirmation_pending
    post "resend-confirmation", to: "confirmations#resend", as: :public_resend_confirmation
    get "forgot-password", to: "password_resets#new", as: :public_forgot_password
    post "forgot-password", to: "password_resets#create"
    get "reset-password", to: "password_resets#edit", as: :public_edit_password_reset
    patch "reset-password", to: "password_resets#update", as: :public_password_reset

    # Customer enrollment and join requests
    scope "/catalog/courses/:course_slug/offerings/:offering_slug" do
      resource :enrollment_request, only: [ :new, :create ]
    end
    scope "/catalog/excursions/:excursion_slug" do
      resource :join_request, only: [ :new, :create ]
    end

    # Customer dashboard
    scope "/my", as: :my do
      resource :dashboard, only: [ :show ], controller: "dashboard"
      resource :profile, only: [ :show, :edit, :update ], controller: "profile"
      resources :certifications, only: [ :index, :new, :create ]
    end

    # Waitlist and cancellations
    resources :waitlist_entries, only: [ :create, :destroy ]
    post "cancel-enrollment/:id", to: "cancellations#cancel_enrollment", as: :cancel_enrollment
    post "cancel-join/:id", to: "cancellations#cancel_join", as: :cancel_join
  end

  # Settings (owner only)
  namespace :settings do
    resource :domain, only: [ :show, :update ] do
      post :verify, on: :member
    end
  end

  # Caddy on-demand TLS verification
  get "caddy/ask", to: "caddy#ask"

  # Staff review queue
  resource :review_queue, only: [ :show ], controller: "review_queue"
  resources :enrollment_reviews, only: [] do
    member do
      post :approve
      post :decline
    end
  end
  resources :join_request_reviews, only: [] do
    member do
      post :approve
      post :decline
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
