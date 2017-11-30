#!/bin/bash
set -e

echo "Executing bundle exec 'rake db:migrate' ..."
RAILS_ENV=production bundle exec rake db:migrate
echo "Seeding the database with 'rake db:seed' ..."
RAILS_ENV=production bundle exec rake db:seed
