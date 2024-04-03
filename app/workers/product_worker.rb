require "sidekiq"
require_relative "../../config/database"
require_relative "../models/product"

class ProductWorker
  include Sidekiq::Worker

  def perform(name)
    DB.transaction do
      Product.create(name: name)
    rescue Sequel::Error => e
      # Here the exception must be handled according to the business logic
      puts "An error occurred while creating the product: #{e.message}"
    end
  end
end
