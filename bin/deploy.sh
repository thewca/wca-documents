#!/bin/bash

aws s3 sync build s3://$DOCUMENTS_BUCKET/ --acl public-read
