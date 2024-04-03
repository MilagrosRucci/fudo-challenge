SECRET_KEY = ENV["SECRET_KEY"]
RACK_ENV = ENV["RACK_ENV"] || "development"
REDIS_PORT = 6379
REDIS_DB = ENV["RACK_ENV"] == "development" ? 0 : 1
