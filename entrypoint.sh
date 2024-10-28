#!/bin/sh

rm -rf ./tmp/pids/server.pid
bundle install
bundle exec bin/rails db:prepare

bundle exec bin/dev
# bundle exec rails server -b '0.0.0.0' -e development