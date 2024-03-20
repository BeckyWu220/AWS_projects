#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Info: $0 missing <output_file>, output file would be stored in current directory."
    output_file='./chefstation_credentials'
else
    # Define output file path from the argument
    output_file="$1"
    
fi

# Load env variables from .env file
set -a
. .env
set +a

sed "s/PLACEHOLDER1/$NODE_NAME/g" "./chefstation_credentials_template" | \
    sed "s#PLACEHOLDER2#$CHEF_SERVER_URL#g" > $output_file

echo "Values injected successfully into $output_file"