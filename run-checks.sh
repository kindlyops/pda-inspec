#!/bin/bash

# don't use set -e because the inspec command will have an exit code when compliance checks
# fail, and we want to keep running checks, not abort the script.
#set -e

# uncomment to debug
# set -x

#echo "Pulling inspec docker container..."
#docker pull chef/inspec


target_server=$1

if [ "$target_server" == "" ]; then
  echo "Missing target server to scan via ssh"
  exit 1
fi

user=`whoami` # chanage this line to override ssh user
#user='ubuntu'

#inspec="docker run -it --rm -v $SSH_AUTH_SOCK:/tmp/agent.sock -e 'SSH_AUTH_SOCK=/tmp/agent.sock' chef/inspec"
inspec=`command -v inspec 2> /dev/null`
if [ "$inspec" == "" ]; then
  echo "Could not find inspec command, see https://github.com/chef/inspec for installation"
  exit 1
fi

compliance_profiles='dev-sec/ssh-baseline dev-sec/linux-baseline dev-sec/linux-patch-baseline'

for profile in $compliance_profiles; do
  echo "Running inspec profile $profile"
  $inspec  supermarket exec $profile -t ssh://$user@$target_server
done
