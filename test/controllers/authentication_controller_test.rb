require_relative "../test_helper"

class AuthenticationControllerTest < Minitest::Test
  include RackAppTestHelper

  def test_successful_login
    User.create(username: "valid_user", password: "valid_password")
    post "/login", { username: "valid_user", password: "valid_password" }
    assert last_response.ok?
    refute_nil JSON.parse(last_response.body)["token"]
  end

  def test_failed_login
    User.create(username: "invalid_user", password: "valid_password")
    post "/login", { username: "invalid_user", password: "wrong_password" }
    refute last_response.ok?
    assert_equal "Invalid credentials", JSON.parse(last_response.body)["error"]
  end

  def test_login_with_nonexistent_user
    post "/login", { username: "nonexistent_user", password: "any_password" }
    refute last_response.ok?
    assert_equal "Invalid credentials", JSON.parse(last_response.body)["error"]
  end
end
