---
name: ci-cd-automation
description: "自動化 build/test/deployment pipeline 的品質門檻與流程設計。Use when setting up CI/CD pipelines, automating quality gates, or configuring deployment workflows."
---

# CI/CD Automation

## 架構描述
自動化 build、test、deployment pipeline，確保每次變更都通過品質門檻。

## 觸發方式
- 「建立 CI/CD」「設定 pipeline」「自動化部署」
- 設定 GitHub Actions、GitLab CI、或其他 CI 系統時

## 執行流程

### 1. Pipeline 設計
- Build → Test → Lint → Security Scan → Deploy
- 每個階段失敗即中止（fail-fast）

### 2. 品質門檻
- 單元測試通過率 100%
- Lint 零錯誤
- 安全掃描無 critical/high
- Code coverage ≥ 80%

### 3. 部署策略
- Staging → Production（分階段）
- Canary / Blue-Green / Rolling update
- 每次部署可回滾

### 4. kiro-cli headless 整合
```bash
kiro-cli chat --no-interactive --trust-all-tools "執行任務"
```
- 需要 KIRO_API_KEY 環境變數
- 適用 Pro/Pro+/Power 訂閱

## 驗收標準
- [ ] Pipeline 定義檔存在且語法正確
- [ ] 所有品質門檻已設定
- [ ] 部署可回滾
- [ ] 文件已更新
