# config/initializers/sidekiq.rb
require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-cron'

redis_config = { url: ENV.fetch('REDIS_URL') }

Sidekiq.configure_server do |config|
  config.redis = redis_config

  # Schedule cron jobs
  schedule_file = "config/sidekiq.yml"
  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)[:scheduler]
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

# Configure Sidekiq Web UI
Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(username),
    ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_WEB_USER', 'admin'))
  ) &
  ActiveSupport::SecurityUtils.secure_compare(
    ::Digest::SHA256.hexdigest(password),
    ::Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_WEB_PASSWORD', 'password'))
  )
end