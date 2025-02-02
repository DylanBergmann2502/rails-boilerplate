# config/routes.rb
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # Health checks
  get "up" => "rails/health#show", as: :rails_health_check
  get "_health" => "health#show", as: :health_check

  # Mount Sidekiq web UI
  # Note: In production, you'll want to add authentication before mounting this
  mount Sidekiq::Web => '/sidekiq'

  scope :api do
    scope :v1 do
      devise_for :users,
        defaults: { format: :json },
        path: '',
        path_names: {
          sign_in: 'login',
          sign_out: 'logout',
          registration: 'signup'
        },
        controllers: {
          sessions: 'api/v1/sessions',
          registrations: 'api/v1/registrations'
        }
    end
  end
end
