require "minitest/autorun"
require "rack/test"
require "sidekiq/testing"
require_relative "../app.rb"
require_relative "../app/models/user"

Sidekiq::Testing.inline!

ENV["RACK_ENV"] = "test"

module RackAppTestHelper
  include Rack::Test::Methods

  def app
    FUDO_APP
  end

  def login_and_get_token
    create_user
    post "/login", { username: "test_user", password: "test_password" }

    JSON.parse(last_response.body)["token"]
  end

  private

  def create_user
    if !User.where(username: "test_user").first
      User.create(username: "test_user", password: "test_password")
    end
  end
end
