require "json"
require_relative "../workers/product_worker"
require_relative "../models/product"

class ProductsController

  def get_products
   Product.all.map { |product| { id: product[:id], name: product[:name] } }
  end

  def create_product(name)
    message = if product_exists?(name)
        "The product '#{name}' already exists"
      else
        ProductWorker.perform_in(5, name)
        "The product '#{name}' has been created successfully"
      end

    { message: message }
  end

  private

  def product_exists?(name)
    Product.where(name: name).count > 0
  end
end
