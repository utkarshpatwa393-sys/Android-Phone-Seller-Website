#!/bin/bash
# ==============================================================================
# AWS Zero-Cost Deployment Script for Project 1 (Private S3 + CloudFront OAC)
# Author: Utkarsh Patwa (@utkarshx96)
# ==============================================================================

set -e

STACK_NAME="android-phone-seller-hosting"
REGION="us-east-1"

echo "================================================================="
echo " Starting Deployment of Project 1: Static Web Hosting with OAC"
echo " Stack: $STACK_NAME | Region: $REGION"
echo "================================================================="

# 1. Deploy CloudFormation Stack
echo ""
echo "[Step 1/3] Deploying AWS CloudFormation Infrastructure..."
aws cloudformation deploy \
  --template-file cloudformation.yaml \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --capabilities CAPABILITY_NAMED_IAM

# 2. Extract Outputs
echo ""
echo "[Step 2/3] Fetching Stack Outputs..."
BUCKET_NAME=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --query "Stacks[0].Outputs[?OutputKey=='S3BucketName'].OutputValue" \
  --output text)

DIST_ID=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --query "Stacks[0].Outputs[?OutputKey=='CloudFrontDistributionId'].OutputValue" \
  --output text)

LIVE_URL=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --region "$REGION" \
  --query "Stacks[0].Outputs[?OutputKey=='LiveWebsiteURL'].OutputValue" \
  --output text)

echo "Target S3 Bucket: $BUCKET_NAME"
echo "CloudFront ID:    $DIST_ID"
echo "Live Website URL: $LIVE_URL"

# 3. Upload Static Assets to Private S3
echo ""
echo "[Step 3/3] Uploading index.html to private S3 bucket..."
aws s3 cp index.html "s3://$BUCKET_NAME/index.html" \
  --content-type "text/html" \
  --region "$REGION"

# 4. Invalidate CloudFront Cache
echo ""
echo "Creating CloudFront cache invalidation..."
aws cloudfront create-invalidation \
  --distribution-id "$DIST_ID" \
  --paths "/*" \
  --region "$REGION" > /dev/null

echo ""
echo "================================================================="
echo " 🎉 DEPLOYMENT COMPLETE!"
echo " Your project is live at:"
echo " 👉 $LIVE_URL"
echo "================================================================="
