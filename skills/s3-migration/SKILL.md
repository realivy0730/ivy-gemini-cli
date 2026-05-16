---
name: s3-migration
description: "規劃與執行 S3 Bucket 遷移，包含清單分析、資料同步、驗證與清理。用於整合、搬遷或歸檔 S3 Bucket。 Use when migrating data to or from AWS S3."
---

# S3 Bucket 遷移整併

## 架構描述
S3 Bucket 遷移整併工具，支援跨 Region/跨帳號遷移、多 Bucket 合併至單一目標、資料驗證與清理。基於實際 backup buckets 整併經驗設計。

## 觸發方式
- "遷移 S3 bucket [source] 到 [target]"
- "整併 S3 buckets"
- "S3 搬遷計畫"

## 執行流程

### Phase 1: 盤點分析
1. 列出來源 Bucket 清單與 Region
2. 分析儲存類別分佈 (Standard / IA / Glacier)
3. 計算總容量與物件數量

### Phase 2: 遷移規劃
1. 決定目標 Bucket 結構 (prefix 規劃)
2. 評估遷移方式: `aws s3 sync`(<100GB) / S3 Batch Operations(>100GB) / S3 Replication(持續同步)
3. 建立回滾方案

### Phase 3: 執行遷移
1. 建立目標 Bucket (含 Lifecycle Policy)
2. 執行資料同步、監控進度

### Phase 4: 驗證與清理
1. 比對物件數量與大小
2. 抽樣驗證 ETag/Checksum
3. 刪除來源 Bucket、更新 DNS/應用程式

### Phase 5: Lifecycle-based Cleanup
大量版本物件的自動清理方案，詳見 `references/workflow-and-commands.md`。

## 驗收標準
- [ ] 來源與目標物件數量、容量一致
- [ ] 抽樣 ETag 比對通過
- [ ] 應用程式配置已更新
- [ ] 來源 Bucket 已清理

## 注意事項
- 跨 Region 傳輸會產生 Data Transfer 費用
- Glacier 物件需先 Restore 才能複製
- 保留回滾方案，不要立即刪除來源
- `TransitionDefaultMinimumObjectSize` 預設 128KB
