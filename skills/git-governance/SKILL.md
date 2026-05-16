---
name: git-governance
description: "Generate Git commands and MR descriptions conforming to global verbose description standards. Use when committing code, creating merge requests, or preparing PR descriptions that must follow gitflow and IDD conventions."
version: "1.0.0"
---

# Git Governance Skill

自動產出符合全域詳盡描述規範的 Git 指令與 MR 描述。

## 觸發條件
- 準備 commit message 時
- 建立 MR/PR 描述時
- 需要符合 gitflow 規範的分支操作時

## 執行規範
- Commit Message 100% 正體中文（type prefix 例外）
- 必須包含 Why, What, Result
- MR 描述必須關聯 Issue（`Fixes #N` / `Closes #N`）

## 參考規範
- `~/.kiro/steering/foundational/gitflow.md`（分支策略 + Commit 規範）
- `~/.kiro/steering/issue-driven-development.md`（PR/MR 關聯規範）
