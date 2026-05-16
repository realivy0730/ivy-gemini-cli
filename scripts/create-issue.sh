#!/bin/bash
# create-issue.sh — Issue-Driven Development 執行腳本
# 用法: create-issue.sh "<標題>" "<描述>" [標籤]
# 自動偵測 GitHub/GitLab，建立 Issue 並同步 Redmine

set -uo pipefail

TITLE="${1:?用法: $0 <標題> <描述> [標籤]}"
BODY="${2:?缺少描述}"
LABELS="${3:-bug}"

# --- 載入 .env ---
[ -f "$HOME/ivy-kiro-cli/.env" ] && source "$HOME/ivy-kiro-cli/.env" 2>/dev/null

# --- 平台偵測 ---
detect_platform() {
  local url
  url=$(git config --get remote.origin.url 2>/dev/null) || { echo "none"; return; }
  if [[ "$url" == *"github.com"* ]]; then echo "github"
  elif [[ "$url" == *"gitlab"* ]]; then echo "gitlab"
  else echo "none"
  fi
}

PLATFORM=$(detect_platform)

# --- GitHub Issue ---
create_github_issue() {
  if ! command -v gh &>/dev/null; then
    echo "❌ gh CLI 未安裝" >&2; return 1
  fi
  if ! gh auth status &>/dev/null 2>&1; then
    echo "❌ gh 未登入，請執行 gh auth login" >&2; return 1
  fi
  gh issue create --title "$TITLE" --body "$BODY" --label "$LABELS" 2>&1
}

# --- GitLab Issue ---
create_gitlab_issue() {
  if ! command -v glab &>/dev/null; then
    echo "❌ glab CLI 未安裝" >&2; return 1
  fi
  glab issue create --title "$TITLE" --description "$BODY" --label "$LABELS" 2>&1
}

# --- Redmine 同步 ---
sync_redmine() {
  [ -z "${REDMINE_API_KEY:-}" ] && return 0
  [ -z "${REDMINE_BASE_URL:-}" ] && return 0
  local issue_url="$1"
  local desc="$BODY"$'\n\n'"---"$'\n'"關聯：$issue_url"
  local payload
  payload=$(python3 -c "
import json, sys
print(json.dumps({'issue':{'project_id':'${REDMINE_PROJECT_ID:-mis}','tracker_id':7,'priority_id':5,'subject':sys.argv[1],'description':sys.argv[2]}}))
" "$TITLE" "$desc" 2>/dev/null)
  local resp
  resp=$(curl -s -X POST "$REDMINE_BASE_URL/issues.json" \
    -H "X-Redmine-API-Key: $REDMINE_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$payload" 2>/dev/null)
  local rid
  rid=$(echo "$resp" | python3 -c "import json,sys;print(json.load(sys.stdin)['issue']['id'])" 2>/dev/null)
  [ -n "$rid" ] && echo "🔗 Redmine #$rid 已同步" || echo "⚠️ Redmine 同步失敗（非致命）"
}

# --- 主流程 ---
echo "📋 建立 Issue: $TITLE"
echo "   平台: $PLATFORM"

ISSUE_URL=""
case "$PLATFORM" in
  github)
    ISSUE_URL=$(create_github_issue) || exit 1
    echo "✅ GitHub Issue: $ISSUE_URL" ;;
  gitlab)
    ISSUE_URL=$(create_gitlab_issue) || exit 1
    echo "✅ GitLab Issue: $ISSUE_URL" ;;
  *)
    echo "❌ 無法偵測 Git 平台（非 GitHub/GitLab）" >&2; exit 1 ;;
esac

# Redmine 同步
sync_redmine "$ISSUE_URL"
