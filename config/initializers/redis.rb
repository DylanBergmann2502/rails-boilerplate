# config/initializers/redis.rb
require 'redis'

redis_config = {
  url: ENV.fetch('REDIS_URL'),
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
  timeout: 10,
  connect_timeout: 10,
  reconnect_attempts: 3
}

$redis = Redis.new(redis_config)