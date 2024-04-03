require_relative "../../config/database"

class Product < Sequel::Model
  def validate
    super
    errors.add(:name, "cannot be blank") if name.nil? || name.empty?
    errors.add(:name, "must be unique") if Product.where(name: name).count > 0
  end
end
