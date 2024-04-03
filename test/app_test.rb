require_relative "./test_helper"

class AppTest < Minitest::Test
  include RackAppTestHelper

  def test_static_authors_file
    get "/AUTHORS"
    assert last_response.ok?
    assert_equal "Milagros Rucci", last_response.body
  end

  def test_static_openapi_file
    get "/openapi.yaml"
    assert last_response.ok?
  end
end
