---
name: redmine-weekly-sheet
description: Sync Redmine time entries to PHPTeam weekly Google Sheets report. Use when updating weekly work log spreadsheet or syncing Redmine hours to Google Sheets.
---

# Redmine 週報 → Google Sheets 同步 Skill

## 架構描述

從 Redmine 查詢指定日期的工時記錄，自動格式化並寫入 PHPTeam 週工作日誌 Google Sheets。

### 適用場景
- 工時記錄後自動同步（由 redmine-conventions.md 強制連動規則觸發）
- 補填過去日期的工作日誌
- 批次同步整週工時

## 觸發方式

- "同步今天工時到週報"
- "更新週報 4/7"
- "同步本週工時到 Google Sheets"

## 執行方式

### 單日同步
```shell
python3 ~/ivy-kiro-cli/scripts/sync-weekly-sheet.py --date 2026-04-10
```

### 多日同步
```shell
python3 ~/ivy-kiro-cli/scripts/sync-weekly-sheet.py --date 2026-04-07 2026-04-08 2026-04-09 2026-04-10
```

### 今天（預設）
```shell
python3 ~/ivy-kiro-cli/scripts/sync-weekly-sheet.py
```

## 配置

```yaml
google_sheets:
  spreadsheet_id: "1A7xvZZaS_Sqty1c29l0pej-oxucxIMMgLtCRv55tId4"
  worksheet: "張鐙勻 - Ivy"
  credentials: ~/ivy-kiro-cli/credentials/gcp/phpteam/weekly-log-manager-key.json

redmine:
  api_url: https://phpteam.dotmore.com.tw
  api_key: $REDMINE_API_KEY
  user_id: 5

script: ~/ivy-kiro-cli/scripts/sync-weekly-sheet.py
```

## 注意事項

- 金鑰路徑遵循 `credentials-policy.md` 規範
- 無工時記錄的日期寫入空白（清除舊內容）
- 假日/休假由使用者手動標記
- 依賴 `gspread` 套件
