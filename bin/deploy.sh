#!/bin/bash

aws s3 sync build s3://$DOCUMENTS_BUCKET/ --acl public-read
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*" --output text
