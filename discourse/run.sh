#!/bin/bash
set -e

cd /opt/app

case ${1} in
    "")
        #echo "Migrating database..."
        #bin/rake db:migrate
        if [[ ! -d public/assets ]]; then
            echo "Precompiling assets..."
            bin/rake assets:precompile
        fi
        echo "Starting discourse..."
        exec bundle exec unicorn -c config/unicorn.conf.rb
        ;;
    *)
        echo "Running custom command: $@"
        exec $@
        ;;
esac
