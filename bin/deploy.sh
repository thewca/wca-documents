#!/bin/bash

chmod 600 /tmp/deploy_rsa # Allow read access to the private key
ssh -i /tmp/deploy_rsa cubing@$WCA_HOST worldcubeassociation.org/scripts/deploy.sh update_docs
