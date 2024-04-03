require "jwt"
require_relative "../../config/database"
require_relative "../../config/redis"
require_relative "../../config/config"

class Base
  def initialize(controller)
    @controller = controller
  end

  private

  def not_found_response(response)
    response.write({ error: "Not found route" }.to_json)
    response.status = 404
  end

  def method_not_allowed_response(response)
    response.write({ error: "Method not allowed" }.to_json)
    response.status = 405
  end

  def valid_token?(request)
    token = request.params["token"] || request.env["HTTP_AUTHORIZATION"]&.split(" ")&.last
    return false unless token

    decoded_token = JWT.decode(token, SECRET_KEY, true, algorithm: "HS256")
    username = decoded_token[0]["username"]
    REDIS.get(username) == token
  rescue JWT::DecodeError
    false
  end
end
