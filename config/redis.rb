require 'redis'
require_relative './config'

REDIS = Redis.new(host: "localhost", port: REDIS_PORT, db: REDIS_DB)
