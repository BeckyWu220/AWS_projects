#!/bin/bash
echo "Executing entrypoint.sh"

echo "List /opt/chef-workstation/"
ls /opt/chef-workstation/

echo "Generate chef-repo with License silently accepted"
cd /root
chef generate repo chef-repo --chef-license accept-silent
ls ./chef-repo

echo "Copy webserver.rb to chef-repo/cookbooks/example/recipes"
cp /usr/bin/webserver.rb /root/chef-repo/cookbooks/example/recipes/webserver.rb

echo "List Recipes of 'example' Cookbook:"
ls /root/chef-repo/cookbooks/example/recipes

echo "Include 'webserver' Recipe to default Recipe and print default.rb."
echo "include_recipe 'example::webserver'" >> /root/chef-repo/cookbooks/example/recipes/default.rb
cat /root/chef-repo/cookbooks/example/recipes/default.rb

echo "Runlist in local mode."
cd /root/chef-repo/cookbooks
chef-client --local-mode --runlist "recipe[example]"

echo "Finished Executing entrypoint.sh"