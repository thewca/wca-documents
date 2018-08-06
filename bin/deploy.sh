#!/bin/bash

eval "$(ssh-agent -s)" # Start ssh-agent cache
chmod 600 /tmp/deploy_rsa # Allow read access to the private key
ssh-add /tmp/deploy_rsa # Add the private key to SSH
ssh cubing@$WCA_HOST worldcubeassociation.org/scripts/deploy.sh update_docs
