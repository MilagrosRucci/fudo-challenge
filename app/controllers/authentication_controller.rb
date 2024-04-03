require_relative "../models/user"

class AuthenticationController
  def login(username, password)
    user = User.where(username: username, password: password).first

    if user
      { message: "Successful login", user: user }
    else
      { error: "Invalid credentials" }
    end
  end
end
