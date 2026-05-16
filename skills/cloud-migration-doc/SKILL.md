---
name: cloud-migration-doc
description: "產生跨雲遷移文件，包含服務對照、遷移步驟、風險評估與回滾計畫。用於規劃 AWS/GCP/Azure 間的遷移專案。 Use when documenting cloud migration strategies or procedures."
---

# 跨雲遷移文件生成

## 架構描述
根據現有雲端架構，自動生成遷移至目標雲端的技術文件。支援 AWS、GCP、Azure、IDC 之間的任意遷移方向。產出包含服務對應表、遷移步驟、風險評估與回滾方案。

## 觸發方式
- "生成 [來源雲] 到 [目標雲] 的 [服務類型] 遷移文件"
- "規劃 AWS ELB 到 GCP Load Balancer 遷移"
- "建立跨雲遷移計畫"

## 遷移前評估問題（Assessment Questions 模式）

遷移前先釐清以下問題：

1. 來源和目標環境分別是什麼？（AWS→GCP / GCP→AWS / 地端→雲端）
2. 資料量多大？有即時性要求嗎？
3. 停機時間容忍度？（零停機 / 維護窗口 / 可接受短暫中斷）
4. 有哪些相依服務需要同步遷移？
5. 合規要求？（資料落地、加密、稽核）

## 執行流程

### Phase 1: 分析來源架構
1. 從 knowledge base 查詢來源雲架構配置
3. 擷取關鍵配置參數（服務類型、規格、網路拓撲）

### Phase 2: 查詢目標服務文件
1. 使用 context7 查詢目標雲 SDK/API 文件
2. 使用 aws-docs（若目標為 AWS）查詢服務規格
3. 建立來源→目標服務對應表

### Phase 3: 規劃遷移步驟
1. 使用 sequential-thinking 規劃遷移順序
2. 識別相依性與前置條件
3. 定義每步驟的驗收標準

### Phase 4: 生成文件
1. 產出 `migration-plan.md`
2. 產出 `migration-config.yaml`
3. 輸出至 ~/Downloads/

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: cloud-migration-doc
  version: 1.0
  scope: global

inputs:
  source_cloud: [aws, gcp, azure, idc]
  target_cloud: [aws, gcp, azure, idc]
  service_type: string

output_structure:
  migration-plan.md:
    sections:
      - 服務對應表
      - 遷移步驟
      - 風險評估
      - 回滾方案
      - 驗收標準
  migration-config.yaml:
    sections:
      - source_config
      - target_config
      - mapping_rules
```

## 驗收標準
- [ ] 來源架構已從知識庫取得
- [ ] 目標服務文件已查詢
- [ ] 服務對應表完整（無遺漏服務）
- [ ] 遷移步驟可獨立執行與驗證
- [ ] 回滾方案已定義
- [ ] 文件已輸出至 ~/Downloads/

## 注意事項
- 遷移前必須確認來源知識庫為最新版本
- 跨雲網路連線（VPN/Peering）需額外規劃
- 資料遷移需評估頻寬與時間成本
- 安全性設定（IAM/防火牆）不可直接複製，需重新設計
