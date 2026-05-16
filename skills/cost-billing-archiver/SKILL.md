---
name: cost-billing-archiver
description: Archive monthly cloud and IDC vendor billing statements to Google Drive using cost-billing-manager service account. Use when organizing billing documents, uploading invoices, or managing cost reports.
---

# Cost Billing Archiver — 成本對帳單歸檔

## 架構描述

使用 `cost-billing-manager` Service Account 將每月雲端（AWS/GCP/Azure）及 IDC 代理商成本對帳單歸檔到 Google Drive，並整理到 Google Sheets。

## 觸發方式

- 「歸檔本月對帳單」
- 「上傳帳單到 Google Drive」
- 「整理成本報告」

## 前置條件

1. Service Account：`cost-billing-manager@phpteam.iam.gserviceaccount.com`
2. 金鑰路徑：`~/ivy-kiro-cli/credentials/gcp/phpteam/cost-billing-manager-key.json`
3. 已啟用 API：Google Drive API + Google Sheets API
4. 目標 Drive 資料夾需共享給 Service Account email

## 執行流程

### 1. 認證

```python
from google.oauth2 import service_account
from googleapiclient.discovery import build

SCOPES = [
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/spreadsheets'
]
KEY_PATH = '~/ivy-kiro-cli/credentials/gcp/phpteam/cost-billing-manager-key.json'

creds = service_account.Credentials.from_service_account_file(KEY_PATH, scopes=SCOPES)
drive_service = build('drive', 'v3', credentials=creds)
sheets_service = build('sheets', 'v4', credentials=creds)
```

### 2. 歸檔流程

```
取得對帳單檔案（PDF/Excel/CSV）
    ↓
上傳到 Google Drive 指定資料夾
    ↓
依雲端供應商分類（aws/gcp/azure/idc）
    ↓
更新 Google Sheets 彙總表
    ↓
記錄到工作目錄的 CHANGELOG.md
```

### 3. Drive 資料夾結構

```
成本對帳單/
├── {YYYY}/
│   ├── {MM}/
│   │   ├── aws/
│   │   ├── gcp/
│   │   ├── azure/
│   │   └── idc/
```

## 配置數據 (kiro-cli config)

```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: cost-billing-archiver
  version: "1.0.0"
  scope: global

config:
  service_account: cost-billing-manager@phpteam.iam.gserviceaccount.com
  key_path: ~/ivy-kiro-cli/credentials/gcp/phpteam/cost-billing-manager-key.json
  apis:
    - drive.googleapis.com
    - sheets.googleapis.com
  vendors:
    - aws
    - gcp
    - azure
    - idc
```

## 驗收標準

- [ ] 檔案成功上傳到 Google Drive
- [ ] 資料夾結構正確（年/月/供應商）
- [ ] Google Sheets 彙總表已更新
- [ ] CHANGELOG.md 已記錄

## 注意事項

- Drive 資料夾需先手動共享給 `cost-billing-manager@phpteam.iam.gserviceaccount.com`
- 金鑰路徑使用環境變數引用，禁止硬編碼
- 上傳前確認檔案格式（PDF/Excel/CSV）
