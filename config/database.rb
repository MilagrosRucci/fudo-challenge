require "sequel"
require_relative "./config"

DB = Sequel.sqlite("db/database_#{RACK_ENV}.sqlite3")

DB.create_table? :users do
  primary_key :id
  String :username, null: false, unique: true
  String :password, null: false
end

DB.create_table? :products do
  primary_key :id
  String :name, null: false, unique: true
end
