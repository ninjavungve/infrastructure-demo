#!/bin/bash
set -e

cd /mattermost
sed -Ei "s/\\{\\{DB_PASS\\}\\}/${DB_PASS}/" config/config.json
sed -Ei "s/\\{\\{SMTP_PASS\\}\\}/${SMTP_PASS}/" config/config.json
sed -Ei "s/\\{\\{MATTERMOST_SECRET_KEY\\}\\}/${MATTERMOST_SECRET_KEY}/" config/config.json
sed -Ei "s/\\{\\{MATTERMOST_LINK_SALT\\}\\}/${MATTERMOST_LINK_SALT}/" config/config.json
sed -Ei "s/\\{\\{MATTERMOST_RESET_SALT\\}\\}/${MATTERMOST_RESET_SALT}/" config/config.json
sed -Ei "s/\\{\\{MATTERMOST_INVITE_SALT\\}\\}/${MATTERMOST_INVITE_SALT}/" config/config.json

case ${1} in
    "")
        echo "Starting mattermost..."
        exec bin/platform -config=config/config.json
        ;;
    *)
        echo "Running custom command: $@"
        $@
        ;;
esac
