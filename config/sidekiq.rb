require 'sidekiq'
require_relative './config'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://localhost:#{REDIS_PORT}/#{REDIS_DB}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://localhost:#{REDIS_PORT}/#{REDIS_DB}" }
end
