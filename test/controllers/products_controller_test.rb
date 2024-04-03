require_relative "../test_helper"
require_relative "../../app/models/product"

class ProductsControllerTest < Minitest::Test
  include RackAppTestHelper

  def http_headers
    @http_headers ||= { "HTTP_AUTHORIZATION" => "Bearer #{login_and_get_token}" }
  end

  def test_get_products
    get "/products", {}, http_headers
    assert last_response.ok?
    assert_instance_of Array, JSON.parse(last_response.body)
  end

  def test_get_products_without_token
    get "/products"
    assert_equal 401, last_response.status
    assert_equal "Invalid authentication token", JSON.parse(last_response.body)["error"]
  end

  def test_get_products_with_invalid_token
    get "/products", {}, { "HTTP_AUTHORIZATION" => "Bearer invalid_token" }
    assert_equal 401, last_response.status
    assert_equal "Invalid authentication token", JSON.parse(last_response.body)["error"]
  end

  def test_create_product_success
    initial_product_count = Product.count
    post "/products", { name: "new_product" }, http_headers
    assert_equal 201, last_response.status
    assert_equal "The product 'new_product' has been created successfully", JSON.parse(last_response.body)["message"]

    assert_equal initial_product_count + 1, Product.count, "Product count did not increase by 1 after creating a new product"
  end

  def test_create_product_without_token
    post "/products", { name: "new_product" }
    assert_equal 401, last_response.status
    assert_equal "Invalid authentication token", JSON.parse(last_response.body)["error"]
  end

  def test_create_product_with_invalid_token
    post "/products", { name: "new_product" }, { "HTTP_AUTHORIZATION" => "Bearer invalid_token" }
    assert_equal 401, last_response.status
    assert_equal "Invalid authentication token", JSON.parse(last_response.body)["error"]
  end

  def test_create_existing_product
    Product.create(name: "existing_product")
    initial_product_count = Product.count

    post "/products", { name: "existing_product" }, http_headers
    assert_equal 201, last_response.status
    assert_equal "The product 'existing_product' already exists", JSON.parse(last_response.body)["message"]
    assert_equal initial_product_count, Product.count, "Product count increased after creating an existing product"
  end
end
