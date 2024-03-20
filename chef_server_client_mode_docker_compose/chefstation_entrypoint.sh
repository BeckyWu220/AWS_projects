#!/bin/bash
echo "Executing entrypoint.sh"

echo "List /opt/chef-workstation/"
ls /opt/chef-workstation/

echo "Checking .chef"
test ~/.chef && echo .chef exists || echo .chef not found

echo "Generate chef-repo with License silently accepted"
cd /root
chef generate repo chef-repo --chef-license accept-silent
ls ./chef-repo

echo "Copy credential file to ~/.chef"
cp /usr/bin/credentials ~/.chef/credentials
cat $CLIENT_KEY_FILE >> ~/.chef/chefstation_client_key.pem

# echo "Copy private key in order to bootstrap Chef client."
mkdir -p ~/home/.ssh
cat $PRI_KEY >> ~/home/.ssh/chef_client_key.pem

echo "Verify Client-to-Server Communication"
knife client list

echo "Copy webserver.rb to chef-repo/cookbooks/example/recipes"
cp /usr/bin/webserver.rb /root/chef-repo/cookbooks/example/recipes/webserver.rb

echo "List Recipes of 'example' Cookbook:"
ls /root/chef-repo/cookbooks/example/recipes

echo "Include 'webserver' Recipe to default Recipe and print default.rb."
echo "include_recipe 'example::webserver'" >> /root/chef-repo/cookbooks/example/recipes/default.rb
cat /root/chef-repo/cookbooks/example/recipes/default.rb

# Replace it with running on a separate client. 
echo "Runlist in local mode."
cd /root/chef-repo/cookbooks
chef-client --local-mode --runlist "recipe[example]"

echo "Executing CMD: $@"
for arg in "$@"; do
    echo "Argument: $arg"
done
exec "$@"