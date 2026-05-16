#!/bin/bash
# 判斷平台並建立 Issue
PLATFORM=$(git remote -v | grep -q 'gitlab' && echo "gitlab" || echo "github")

create_issue() {
  TITLE=$1
  DESC=$2
  if [ "$PLATFORM" == "github" ]; then
    gh issue create --title "$TITLE" --body "$DESC"
  else
    glab issue create --title "$TITLE" --description "$DESC"
  fi
}

# 若存在 REDMINE_API_KEY 則同步
sync_to_redmine() {
  if [ -n "$REDMINE_API_KEY" ]; then
    curl -X POST "$REDMINE_URL/issues.json" \
      -H "X-Redmine-API-Key: $REDMINE_API_KEY" \
      -d '{"issue": {"project_id": "'"$REDMINE_PROJ"'", "subject": "'"$1"'", "description": "'"$2"'"}}'
  fi
}
