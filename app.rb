require "rack"
require "rack/session/cookie"
require "rack/deflater"
require "rack/cache"
require "json"
require "bundler/setup"
require "webrick"
require_relative "config/config"

# Require all Ruby files in the controllers directory
Dir.glob("./app/controllers/*.rb").each { |file| require file }

# Require all Ruby files in the middlewares directory
Dir.glob("./app/middlewares/*.rb").each { |file| require file }

CACHE_METASTORE = "file:/var/cache/rack/meta"
CACHE_ENTITYSTORE = "file:/var/cache/rack/body"
CACHE_DEFAULT_TTL = 24 * 60 * 60

# Rack application configuration
FUDO_APP = Rack::Builder.new do
  use Rack::Session::Cookie, secret: SECRET_KEY
  use Rack::Deflater

  use Rack::Cache,
      verbose: true,
      metastore: CACHE_METASTORE,
      entitystore: CACHE_ENTITYSTORE,
      default_ttl: CACHE_DEFAULT_TTL

  use Rack::Static,
    urls: ["/AUTHORS"],
    root: "public",
    headers: { "Cache-Control" => "public, max-age=86400" }

  use Rack::Static,
      urls: ["/openapi.yaml"],
      root: "public",
      headers: { "Cache-Control" => "no-store" }

  map "/login" do
    run AuthenticationMiddleware.new(AuthenticationController.new())
  end

  map "/products" do
    run ProductsMiddleware.new(ProductsController.new())
  end

  # Not found route handler
  run lambda { |env|
    [404, { "Content-Type" => "application/json" }, [{ error: "Not found route" }.to_json]]
  }
end

Rack::Handler::WEBrick.run FUDO_APP, Host: "0.0.0.0", Port: 9393 unless RACK_ENV == "test"
