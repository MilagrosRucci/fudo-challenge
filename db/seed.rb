require "sequel"
require_relative "../config/database"

5.times do |i|
  DB[:users].insert(username: "user#{i + 1}", password: "password#{i + 1}")
end

50.times do |i|
  DB[:products].insert(name: "Product #{i + 1}")
end
