---
name: code-adversary
description: "對抗性程式碼審查，使用雙模型交互審核挖掘邏輯漏洞與安全風險。Use when reviewing critical code changes, validating deployment readiness, or performing security audits before production release."
---

# Code Adversary Skill

## 觸發條件
- 部署前安全審查（deploy-check 協作）
- 關鍵程式碼變更的對抗性審核
- task-executor 完成後的品質閘門

## 執行流程

```
接收代碼 → Qwen-Coder 產出 → DeepSeek-R1 對抗審查 → 評分 → 通過/阻斷
```

## 審查維度
1. **邏輯漏洞** — 邊界條件、競態條件、空值處理
2. **安全風險** — 注入攻擊、權限繞過、敏感資料洩漏
3. **效能陷阱** — N+1 查詢、記憶體洩漏、無限迴圈
4. **可維護性** — 過度耦合、魔術數字、缺乏錯誤處理

## 評分標準
- **>= 70 分**：通過，可部署
- **< 70 分**：阻斷，必須修復後重新審查

## 驗收標準
- [ ] 雙模型交互審核完成
- [ ] 評分報告已產出
- [ ] 低於閾值時已阻斷部署
