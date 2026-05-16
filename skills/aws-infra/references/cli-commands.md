# AWS CLI 常用操作指令參考

## EC2
```shell
aws ec2 describe-instances --region ap-east-2
aws ec2 start-instances --instance-ids i-xxx --region ap-east-2
aws ec2 stop-instances --instance-ids i-xxx --region ap-east-2
```

## S3
```shell
aws s3api list-buckets --region ap-east-2
aws s3 sync ./local s3://bucket/prefix --region ap-east-2
aws s3api get-public-access-block --bucket bucket-name
```

## CloudFront
```shell
aws cloudfront list-distributions
aws cloudfront create-invalidation --distribution-id E123 --paths "/*"
```

## RDS
```shell
aws rds describe-db-instances --region ap-east-2
aws rds create-db-snapshot --db-instance-identifier mydb --db-snapshot-identifier mydb-snapshot
```

## Route53
```shell
aws route53 list-hosted-zones
aws route53 list-resource-record-sets --hosted-zone-id Z1D77VVFV0KN6V

# 變更 DNS 記錄 (Alias → S3 Website)
aws route53 change-resource-record-sets \
  --hosted-zone-id Z1D77VVFV0KN6V \
  --change-batch '{
    "Changes": [{"Action": "UPSERT", "ResourceRecordSet": {
      "Name": "www.example.com", "Type": "A",
      "AliasTarget": {"HostedZoneId": "Z2M4EHUR26P7ZW",
        "DNSName": "s3-website-ap-northeast-1.amazonaws.com",
        "EvaluateTargetHealth": false}}}]}'

aws route53 get-change --id /change/CXXXXXXXXXXXX
```

## ELB (ALB)
```shell
aws elbv2 describe-load-balancers --region ap-east-2
aws elbv2 describe-listeners --load-balancer-arn <ARN> --region ap-east-2
aws elbv2 modify-listener --listener-arn <LISTENER_ARN> \
  --default-actions 'Type=redirect,RedirectConfig={Protocol=HTTPS,Host=www.target.com,StatusCode=HTTP_301}' \
  --region ap-east-2
aws elbv2 describe-target-health --target-group-arn <TG_ARN> --region ap-east-2
```

## S3 Website Redirect
```shell
aws s3api put-bucket-website --bucket example.com \
  --website-configuration '{"RedirectAllRequestsTo":{"HostName":"www.target.com","Protocol":"https"}}' \
  --region ap-northeast-1
aws s3api get-bucket-website --bucket example.com --region ap-northeast-1
```
