#!/bin/sh
export RACK_ENV=development
redis-server &
sidekiq -r ./app/workers/product_worker.rb &
ruby ./app.rb