---
name: project-init
description: "初始化專案結構，包含目錄建立、配置檔案、知識庫設定與 Git 初始化。用於建立新專案。 Use when initializing a new project or workspace."
---

# Project Init

## 架構描述
自動初始化專案結構，包含目錄建立、配置檔生成、知識庫設定、Git 初始化。

## 觸發方式
- "初始化專案 [專案名稱]"
- "建立新專案 [類型]"
- "project init [name]"

## 執行流程
1. 建立專案目錄結構
2. 生成基礎配置檔（根據專案類型）
3. 初始化 Git repository
4. 建立 AGENTS.md
5. 建立知識庫目錄與 INDEX.md
6. 加入 kiro-cli knowledge

## 配置數據 (kiro-cli config)
```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: project-init
  version: 1.0
  scope: global

trigger:
  keywords: ["初始化專案", "建立新專案", "project init"]

project_types:
  aws:
    dirs: [docs, scripts, terraform, cloudformation]
    files: [README.md, AGENTS.md, .gitignore]
    
  gcp:
    dirs: [docs, scripts, terraform]
    files: [README.md, AGENTS.md, .gitignore]
    
  nodejs:
    dirs: [src, tests, docs]
    files: [package.json, README.md, AGENTS.md, .gitignore]
    
  python:
    dirs: [src, tests, docs]
    files: [pyproject.toml, README.md, AGENTS.md, .gitignore]

workflow:
  steps:
    - name: 建立目錄結構
      tool: create_directory
      params:
        paths: "${project_type.dirs}"
        
    - name: 生成 AGENTS.md
      tool: write_file
      template: |
        # ${project_name}
        
        ## 專案描述
        ${description}
        
        ## 目錄結構
        ${directory_tree}
        
        ## 本地規範
        - 使用 ${package_manager}
        - 遵循 ${coding_style}
        
        ## Self-correction
        - 錯誤時記錄到 .learnings/LEARNINGS.md
        - 發現配置過時時更新此檔案
        
    - name: 初始化 Git
      tool: execute_bash
      command: |
        git init
        git add .
        git commit -m "Initial commit"
        
    - name: 檢查知識庫是否存在
      tool: knowledge
      action: show
      verification:
        - 檢查 ${project_path} 是否已存在
        - 若存在，使用現有 name
        - 若不存在，執行下一步
        
    - name: 建立知識庫（若不存在）
      tool: knowledge
      action: add
      condition: "knowledge_not_exists"
      params:
        name: "${project_name}"
        value: "${project_path}"
      on_success:
        
      action: sync
      params:
        auto_update: true
      verification:
        - name 正確對應
```

## 驗收標準
- [ ] 目錄結構完整
- [ ] AGENTS.md 已生成
- [ ] Git repository 已初始化
- [ ] 知識庫已建立

## 使用範例
```
使用者: "初始化 AWS 專案 my-lambda"
Kiro:
1. 建立目錄: docs/, scripts/, terraform/
2. 生成 AGENTS.md
3. git init
4. 加入 knowledge
```

## 注意事項
- 專案名稱使用 kebab-case
- 自動偵測專案類型（若未指定）
- 支援自訂模板
