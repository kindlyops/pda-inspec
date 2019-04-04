#!/bin/bash

# don't use set -e because the inspec command will have an exit code when compliance checks
# fail, and we want to keep running checks, not abort the script.
#set -e

# uncomment to debug
set -x

#echo "Pulling inspec docker container..."
#docker pull chef/inspec


inspec=`command -v inspec 2> /dev/null`
if [ "$inspec" == "" ]; then
  echo "Could not find inspec command, see https://github.com/chef/inspec for installation"
  exit 1
fi

compliance_profiles='dev-sec/ssh-baseline dev-sec/linux-baseline dev-sec/linux-patch-baseline'

# Requires inspec v2
for profile in $compliance_profiles; do
  echo "Running inspec profile $profile"
  $inspec  supermarket exec $profile --reporter=cli html:reports/$profile.html json:reports/$profile.json
done
