#!/bin/bash

aws s3 sync build s3://$DOCUMENTS_BUCKET/ --acl public-read
# Update version file so the website will update its cache
git_hash=$(git rev-parse --short "$GITHUB_SHA")
echo "$git_hash" > version
aws s3 cp version s3://$DOCUMENTS_BUCKET/version
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*" --output text
