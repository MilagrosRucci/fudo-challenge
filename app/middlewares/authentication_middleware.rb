require_relative "base"

class AuthenticationMiddleware < Base
  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    case request.path
    when "/login"
      handle_login_request(request, response)
    else
      not_found_response(response)
    end

    response.finish
  end

  private

  def handle_login_request(request, response)
    if request.post?
      username = request.params["username"]
      password = request.params["password"]
      login = @controller.login(username, password)

      if login[:user]
        token = generate_token(login[:user])
        REDIS.setex(username, 3600, token)
        response.write({ token: token }.to_json)
        response.status = 200
      else
        unauthorized_response(response)
      end
    else
      method_not_allowed_response(response)
    end
  end

  def generate_token(user)
    payload = { username: user[:username] }
    token = JWT.encode(payload, SECRET_KEY, "HS256")
    token
  end

  def unauthorized_response(response)
    response.write({ error: "Invalid credentials" }.to_json)
    response.status = 401
  end
end
