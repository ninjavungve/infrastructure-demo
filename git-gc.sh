#!/bin/bash
docker exec -it gitlab bundle exec rake gitlab:git:gc RAILS_ENV=production
