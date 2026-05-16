---
name: prompt-engineering
description: "設計與優化 AI prompt，含五段式結構、反模式偵測與品質自檢。Use when creating steering files, system prompts, or reusable prompt templates."
---

# Prompt Engineering — AI 提示詞工程

## 架構描述

標準化 prompt 撰寫方法論，確保所有 steering、prompts/、agent prompt 的品質一致。

## 觸發方式

- 「撰寫 prompt」「設計 system prompt」「優化提示詞」
- 建立新的 steering 或 prompts/ 檔案時

## 五段式結構（強制）

所有結構化 prompt 必須包含：

```markdown
# 角色設定
明確定義 AI 的專業身份與能力邊界

# 背景脈絡
提供任務的前因後果、現有狀態、約束條件

# 具體任務與步驟
編號列出可驗證的執行步驟

# 輸出格式要求
定義 Markdown 結構、表格、程式碼區塊等格式

# 限制條件
安全邊界、禁止事項、品質底線
```

## 角色設定進階方法（借鑑女娧蒸餾框架）

當需要深度角色扮演時，用四層結構定義角色：

| 層 | 內容 | 範例 |
|---|------|------|
| 心智模型 | 3-5 個核心思維框架 | 「延遲滿足感」「Context not Control」 |
| 決策啟發式 | 可重複套用的決策規則 | 「先小驗證再押大注」 |
| 表達 DNA | 句式、詞彙偏好、確定性分級 | 「短句為主、數學詞彙描述感性問題」 |
| 內在張力 | 角色的矛盾與複雜性 | 「算法中性 vs 平台責任」 |

適用場景：建立 prompts/ 模板、agent prompt、專業顧問角色

## 反模式清單

| 反模式 | 症狀 | 修正 |
|--------|------|------|
| VAGUE_ROLE | 「你是一個助手」 | 明確專業領域 + 能力邊界 |
| NO_CONTEXT | 直接下指令，無背景 | 補充現有狀態和約束 |
| WALL_OF_TEXT | 單段超過 200 字 | 拆分為編號步驟 |
| MISSING_FORMAT | 無輸出格式要求 | 定義 Markdown/表格/Code block |
| OVER_CONSTRAINED | 限制條件 > 任務描述 | 精簡限制，聚焦核心 |
| NO_VERIFICATION | 無驗收標準 | 加入可量化的成功條件 |

## 品質自檢清單

撰寫完成後逐項確認：

- [ ] 角色定義具體（非泛用「助手」）
- [ ] 背景脈絡充足（讀者無需額外資訊即可理解）
- [ ] 任務步驟可驗證（每步有明確輸出）
- [ ] 輸出格式明確（Markdown 結構已定義）
- [ ] 限制條件精簡（≤ 5 條核心限制）
- [ ] 無反模式（通過上表 6 項檢查）
- [ ] Token 效率（無冗餘重複描述）

## 負面約束設計模式（Anthropic Best Practice #5）

正面指令設定目標，負面約束設定邊界。兩者缺一不可。

### 撰寫原則
- 用「不要」「禁止」「避免」明確劃定禁區
- 負面約束數量 ≤ 正面指令數量（避免 OVER_CONSTRAINED）
- 每條約束要具體，不要泛泛而談

### 範例
```
# 限制條件
- 不要使用企業術語或行銷用語
- 不要在單一回應中包含多個請求
- 不要以「如有任何問題請告知」結尾
- 禁止在未查詢文件的情況下直接撰寫程式碼
```

## 推理過程 Few-Shot（Anthropic Best Practice #4）

Few-shot 範例不只展示「輸入→輸出」，還要展示「輸入→推理過程→輸出」。

### 撰寫原則
- 範例中包含思考步驟（不只是最終答案）
- 展示如何處理邊界情況
- 放在 references/ 中做漸進式揭露

### 範例結構
```
# 範例
## 輸入
[使用者的問題或需求]

## 推理過程
1. 首先分析 [X]
2. 考慮到 [Y] 的約束
3. 排除 [Z] 方案因為 [原因]

## 輸出
[最終結果]
```

## 配置數據 (kiro-cli config)

```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: prompt-engineering
  version: "1.0.0"
  scope: global
```

## 驗收標準

- [ ] prompt 包含五段式結構
- [ ] 通過 6 項反模式檢查
- [ ] 通過品質自檢清單
