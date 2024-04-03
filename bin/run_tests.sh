#!/bin/sh
export RACK_ENV=test
rm -f ./db/*_test.sqlite3
ruby ./test/app_test.rb
ruby ./test/controllers/products_controller_test.rb
ruby ./test/controllers/authentication_controller_test.rb