---
name: skill-architect
description: "評估對話中的需求是否應建立或更新 .kiro/skills，含全域攔截與雙重驗收。Use when identifying reusable patterns, proposing new skills, or evaluating skill updates across any workspace."
---

# Skill Architect — Skills 治理鏈核心

## 架構描述
對話中主動識別可重複使用的模式與需求，評估是否需要新建或更新 skill，嚴格區分專案級與全域級，全域級強制攔截討論。

## 觸發方式

### 觸發
- 使用者明確要求「建立 skill」「新增 skill」「更新 skill」
- 對話中反覆出現相同模式的操作流程（≥2 次）
- 使用者描述了一個可自動化的工作流程

### 不觸發
- 純查詢類對話
- 一次性的臨時操作
- 已有 skill 完全覆蓋的場景

## 6 步評估流程

### Step 1: 現有覆蓋度檢查
掃描全域 `~/.kiro/skills/` 和專案級 `.kiro/skills/`，確認是否已有 skill 覆蓋該需求。
- 完全覆蓋 → 不需要（結束，告知使用者現有 skill 名稱）
- 部分覆蓋 → 優先評估「更新現有 skill」
- 無覆蓋 → 進入 Step 2

### Step 2: 合併可能性評估
評估是否可透過更新現有 skill 來滿足需求（加區段或 references/），而非新建。
- 可合併 → 更新現有 skill（加區段或 references/）
- 無法合併 → 進入 Step 3

### Step 3: 層級判定
判定該 skill 的影響範圍：

**全域型條件（滿足任一即為全域）：**
1. 不依賴特定專案的程式碼或配置
2. 跨 ≥2 個工作目錄都可能使用
3. 涉及 kiro-cli 本身的配置管理
4. 涉及通用的開發方法論或工作流程

- 專案級 → 可直接建構（仍需雙重驗收）
- **全域級 → 強制攔截，輸出評估報告，等待使用者確認**

### Step 4: 觸發衝突檢測
確認新 skill 的 description 不與現有 skills 的觸發條件重疊。
- 列出最相近的 3 個現有 skills 及其 description
- 確認觸發邊界清晰，不會同時觸發多個 skills

### Step 5: Token 成本評估
- description 永久載入成本：~40 tokens/skill
- SKILL.md 觸發時載入成本：估算行數
- 若 SKILL.md > 120 行，必須拆分到 references/

### Step 6: 雙重驗收
建構完成後，必須執行雙重驗收（不可省略）：

**第一重 — 邏輯正確性檢查：**
- [ ] YAML frontmatter 合規（name kebab-case、description 含 "Use when"）
- [ ] description ≤ 1024 字元
- [ ] SKILL.md 行數 ≤ 120（超過則拆分 references/）
- [ ] 與現有 skills 無職責重疊
- [ ] code block 外無 XML 角括號
- [ ] 觸發條件精確（不泛觸發）

**第二重 — 預期結果模擬：**
- 模擬 ≥ 3 個使用場景，驗證觸發和輸出是否符合預期
- 詳見 references/evaluation-template.md

## 全域攔截輸出格式

判定為全域型時，必須輸出以下報告後等待確認：

```markdown
## 【全域 Skill 建構攔截】

### 影響範圍
[描述影響的工作目錄和場景]

### 與現有 Skills 的重疊度
[列出最相近的 skills 及差異]

### 建構草案
- name: [kebab-case]
- description: [含 Use when]
- 核心區段: [列出]

### 潛在風險
[列出風險和緩解措施]

### 等待確認
請確認是否同意建構此全域 skill。
```

## Skills 治理鏈定位

```
skill-architect（要不要建？建在哪？）
  → kiro-docs-check（格式對不對？）
  → skills-batch-ops（品質好不好？）
  → kiro-config-manager（配置怎麼改？）
```

## 驗收標準
- [ ] 評估報告包含 6 步完整流程
- [ ] 全域型需求已攔截並等待確認
- [ ] 雙重驗收已執行且全部通過
