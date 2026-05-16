---
name: sre-governance
description: "SRE 治理與規範稽核，強制執行六大規範與對抗審查。Use when auditing compliance with global steering rules, validating task lifecycle adherence, or performing governance checks on any workspace."
---

# SRE Governance Skill

## 觸發條件
- 任務完成後的合規性檢查
- 跨專案治理稽核
- 對抗性審查（code-adversary 協作）

## 執行流程

```
接收稽核請求 → 載入全域 Steering → 逐項比對 → 產出合規報告 → 標記違規項
```

## 稽核項目（六大規範）
1. **知識庫同步鐵律** — CHANGELOG + README + knowledge update 三步完成
2. **Git Push 前置條件** — CHANGELOG 已更新 + README 落差檢測
3. **程式碼協作規範** — context7 查詢 + Clean Code
4. **客觀驗收** — 自動化測試 + 回滾方案
5. **嚴謹除錯** — 科赫法則 + RCA 記錄
6. **自我改進** — LEARNINGS.md 記錄 + 規則提升

## 驗收標準
- [ ] 所有稽核項目已檢查
- [ ] 違規項已標記嚴重度
- [ ] 產出結構化合規報告
