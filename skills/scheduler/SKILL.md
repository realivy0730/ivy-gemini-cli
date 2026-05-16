---
name: scheduler
description: Manage scheduled tasks using crontab and macOS launchd. Create, list, remove periodic jobs for kiro-cli automation. Use when setting up automated sync, periodic reports, or recurring tasks.
---

# Scheduler — 排程任務管理

## 架構描述

封裝 `crontab` 和 macOS `launchd` 的建立/管理/移除，讓 kiro-cli 具備定時自動執行任務的能力。

## 觸發方式

- 「每 30 分鐘同步知識庫」
- 「建立排程任務」
- 「列出所有排程」
- 「移除排程」

## 執行流程

### 方案選擇

| 方案 | 適用場景 | 指令 |
|------|---------|------|
| crontab | 簡單定時任務 | `crontab -e` |
| launchd | 檔案變更觸發、開機自啟、自動重試 | `launchctl` |

**建議**：macOS 優先使用 launchd（系統原生、功能更強）。

### crontab 操作

```bash
# 列出現有排程
crontab -l

# 新增排程（每 30 分鐘同步）
(crontab -l 2>/dev/null; echo "*/30 * * * * cd ~/ivy-kiro-cli && ./scripts/sync-config-only.sh 'auto-sync' >> /tmp/kiro-sync.log 2>&1") | crontab -

# 移除特定排程
crontab -l | grep -v "ivy-kiro-cli" | crontab -
```

### launchd 操作

```bash
# 載入
launchctl load ~/Library/LaunchAgents/com.ivy.kiro-{NAME}.plist

# 卸載
launchctl unload ~/Library/LaunchAgents/com.ivy.kiro-{NAME}.plist

# 列出所有 kiro 排程
launchctl list | grep ivy.kiro

# 手動觸發
launchctl start com.ivy.kiro-{NAME}
```

### launchd plist 模板

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ivy.kiro-{NAME}</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>{COMMAND}</string>
    </array>
    <key>StartInterval</key>
    <integer>{SECONDS}</integer>
    <key>StandardOutPath</key>
    <string>/tmp/kiro-{NAME}.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/kiro-{NAME}.err</string>
    <key>RunAtLoad</key>
    <false/>
</dict>
</plist>
```

### 進階：檔案變更觸發

```xml
<key>WatchPaths</key>
<array>
    <string>/Users/linyuanchun/.kiro/agents</string>
    <string>/Users/linyuanchun/.kiro/steering</string>
</array>
```

## 配置數據 (kiro-cli config)

```yaml
meta:
  owner: Ivy
  type: skill
  skill_id: scheduler
  version: "1.0.0"
  scope: global

config:
  plist_dir: "~/Library/LaunchAgents/"
  plist_prefix: "com.ivy.kiro-"
  log_dir: "/tmp/"
  default_method: "launchd"
```

## 驗收標準

- [ ] 可建立 crontab / launchd 排程
- [ ] 可列出所有 kiro 相關排程
- [ ] 可移除指定排程
- [ ] 日誌輸出正常

## 注意事項

- launchd plist 修改後需 `unload` + `load` 才生效
- crontab 的 PATH 與互動式 shell 不同，指令需用絕對路徑
- 排程中的 kiro-cli 需用 `-p` 非互動模式
- 建議排程間隔 ≥ 5 分鐘
