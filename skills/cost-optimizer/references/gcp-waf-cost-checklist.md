# GCP Well-Architected Framework — Cost Optimization 驗證清單

來源：google/skills google-cloud-waf-cost-optimization

## 核心原則
1. 雲端支出對齊商業價值
2. 培養成本意識文化（FinOps）
3. 優化資源使用
4. 持續優化

## 驗證清單

- **成本歸屬**：100% 資源標記 label（env, team, app）
- **細粒度可見性**：BigQuery billing export 啟用並定期審查
- **預算與警報**：每個專案/業務單位設定預算和主動警報
- **Rightsizing**：定期依 Active Assist Recommender 調整資源
- **承諾策略**：每月審查 CUD 覆蓋率
- **閒置資源**：每月識別並移除未使用的 disk、IP、idle VM
- **託管服務**：新工作負載優先使用 serverless
- **儲存分層**：所有主要 bucket 啟用 lifecycle policy

## 評估問題
- 如何在架構設計中納入成本考量？
- 如何在不同環境（dev/test/prod）優化成本？
- 如何確保成本優化是持續且可持續的？
- 如何衡量成本優化的成效？
