require_relative "base"

class ProductsMiddleware < Base
  def initialize(controller)
    @controller = controller
  end

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    case request.path
    when "/products"
      handle_products_request(request, response)
    else
      not_found_response(response)
    end

    response.finish
  end

  private

  def handle_products_request(request, response)
    case request.request_method
    when "GET"
      handle_get_products(request, response)
    when "POST"
      handle_create_product(request, response)
    else
      method_not_allowed_response(response)
    end
  end

  def handle_get_products(request, response)
    if valid_token?(request)
      products = @controller.get_products
      response.write(products.to_json)
      response.status = 200
    else
      unauthorized_response(response)
    end
  end

  def handle_create_product(request, response)
    if valid_token?(request) && request.params["name"]
      name = request.params["name"]
      result = @controller.create_product(name)

      response.write({ message: result[:message] }.to_json)
      response.status = 201
    else
      unauthorized_response(response)
    end
  end

  def unauthorized_response(response)
    response.write({ error: "Invalid authentication token" }.to_json)
    response.status = 401
  end
end
