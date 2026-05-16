# S3 遷移 Workflow 配置與指令參考

## 配置數據
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: s3-migration
  version: 1.1
  scope: global

workflow:
  inventory:
    - name: 盤點來源 Bucket
      tool: use_aws
      params:
        service_name: s3api
        operation_name: list-objects-v2
        parameters:
          bucket: "${source_bucket}"
    - name: 統計容量
      tool: execute_bash
      params:
        command: "aws s3 ls s3://${source_bucket} --recursive --summarize"

  migration:
    - name: 同步資料 (小量)
      tool: execute_bash
      params:
        command: "aws s3 sync s3://${source} s3://${target} --region ${region}"
    - name: 批次操作 (大量)
      tool: use_aws
      params:
        service_name: s3control
        operation_name: create-job

  verification:
    - name: 比對物件數
      tool: execute_bash
      params:
        command: |
          echo "Source:" && aws s3 ls s3://${source} --recursive --summarize | tail -2
          echo "Target:" && aws s3 ls s3://${target} --recursive --summarize | tail -2
```

## 常用指令
```shell
# 盤點
aws s3 ls s3://bucket-name --recursive --summarize --region ap-east-2

# 同步 (dry-run → 正式)
aws s3 sync s3://source s3://target --dryrun --region ap-east-2
aws s3 sync s3://source s3://target --region ap-east-2

# 跨 Region
aws s3 sync s3://source s3://target --source-region ap-east-2 --region ap-northeast-1

# 驗證
aws s3api list-objects-v2 --bucket target --query 'KeyCount'
```

## Phase 5: Lifecycle-based Cleanup（大量版本物件）

當來源 Bucket 啟用 Versioning 且有大量 noncurrent versions 時，手動批次刪除效率極低。改用 lifecycle 自動清理：

### 5a. 暫停 Versioning
```shell
aws s3api put-bucket-versioning --bucket ${BUCKET} --region ${REGION} \
  --versioning-configuration Status=Suspended
```

### 5b. 設定 Lifecycle 全清（2 規則互補）
```shell
aws s3api put-bucket-lifecycle-configuration --bucket ${BUCKET} --region ${REGION} \
  --lifecycle-configuration '{
    "Rules": [
      {"ID": "ExpireAllObjects", "Status": "Enabled", "Filter": {"Prefix": ""},
       "Expiration": {"Days": 1}, "NoncurrentVersionExpiration": {"NoncurrentDays": 1},
       "AbortIncompleteMultipartUpload": {"DaysAfterInitiation": 1}},
      {"ID": "CleanupDeleteMarkers", "Status": "Enabled", "Filter": {"Prefix": ""},
       "Expiration": {"ExpiredObjectDeleteMarker": true}}
    ]}'
```

- 規則 1: 1天後過期 current + noncurrent + abort multipart
- 規則 2: 自動清理 expired object delete markers
- Lifecycle 每天 UTC 凌晨批次執行，需等 1-3 天完全清空

### 5c. 確認清空後刪桶
```shell
aws s3api list-object-versions --bucket ${BUCKET} --region ${REGION} --max-keys 1
aws s3 rb s3://${BUCKET} --region ${REGION}
```

適用場景: 版本物件 > 10,000 或 delete markers 大量累積的 Bucket。
