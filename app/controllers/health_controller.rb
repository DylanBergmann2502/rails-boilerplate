# app/controllers/health_controller.rb
class HealthController < ApplicationController
  
  def show
    health_status = {
      status: "ok",
      timestamp: Time.current,
      services: {
        database: check_database,
        redis: check_redis,
        sidekiq: check_sidekiq
      }
    }

    if health_status[:services].values.all?
      render json: health_status
    else
      render json: health_status, status: :service_unavailable
    end
  end

  private

  def check_database
    ActiveRecord::Base.connection.active?
  rescue StandardError
    false
  end

  def check_redis
    Redis.new(url: ENV.fetch('REDIS_URL')).ping == 'PONG'
  rescue StandardError
    false
  end

  def check_sidekiq
    ps = Sidekiq::ProcessSet.new
    ps.size.positive?
  rescue StandardError
    false
  end
end