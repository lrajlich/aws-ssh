#!/bin/bash

## Arguments

sudo mkdir -p /var/log/aws-ssh
sudo chown `whoami` /var/log/aws-ssh

exit 0

# Write to specific file... This does not work...
user=`whoami`
sudo bash -c "cat > /usr/lib/cron/tabs/aws-ssh-auto-refresh << EOF
*/5 * * * * ${user} /usr/local/aws-ssh/aws-ssh-auto-refresh >> /var/log/aws-ssh/cron.log 2>> /var/log/aws-ssh/cron.log
EOF"
