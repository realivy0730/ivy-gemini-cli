# GitLab REST API curl 範例

僅在 MCP 工具不支援時使用。

## 查看 Group 資訊
```shell
curl -s --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  "https://gitlab.com/api/v4/groups/128527314" | jq '{id, name, path, description, visibility, web_url}'
```

## 列出 Group 下的 Projects
```shell
curl -s --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  "https://gitlab.com/api/v4/groups/128527314/projects?per_page=100" | \
  jq '.[] | {id, name, path_with_namespace, visibility, default_branch}'
```

## 列出 Subgroups
```shell
curl -s --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  "https://gitlab.com/api/v4/groups/128527314/subgroups" | \
  jq '.[] | {id, name, path, visibility}'
```

## 建立 Subgroup
```shell
curl -s --request POST --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"name":"SUBGROUP_NAME","path":"subgroup-path","parent_id":128527314,"visibility":"private"}' \
  "https://gitlab.com/api/v4/groups"
```

## 建立 Project
```shell
curl -s --request POST --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"name":"PROJECT_NAME","namespace_id":128527314,"visibility":"private","initialize_with_readme":true}' \
  "https://gitlab.com/api/v4/projects"
```

## 管理成員
```shell
# 列出成員
curl -s --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  "https://gitlab.com/api/v4/groups/128527314/members" | \
  jq '.[] | {id, username, name, access_level}'

# 新增成員
curl -s --request POST --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"user_id":USER_ID,"access_level":30}' \
  "https://gitlab.com/api/v4/groups/128527314/members"

# 邀請成員
curl -s --request POST --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"email":"user@example.com","access_level":30}' \
  "https://gitlab.com/api/v4/groups/128527314/invitations"
```

## Issues
```shell
# 列出
curl -s --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  "https://gitlab.com/api/v4/projects/PROJECT_ID/issues?state=opened" | \
  jq '.[] | {iid, title, state, author: .author.name}'

# 建立
curl -s --request POST --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data '{"title":"ISSUE_TITLE","description":"DESCRIPTION"}' \
  "https://gitlab.com/api/v4/projects/PROJECT_ID/issues"
```

## Merge Requests
```shell
curl -s --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  "https://gitlab.com/api/v4/projects/PROJECT_ID/merge_requests?state=opened" | \
  jq '.[] | {iid, title, source_branch, target_branch, author: .author.name}'
```

## Pipelines
```shell
curl -s --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  "https://gitlab.com/api/v4/projects/PROJECT_ID/pipelines?per_page=5" | \
  jq '.[] | {id, status, ref, created_at}'
```

## 使用者資訊
```shell
curl -s --header "PRIVATE-TOKEN: $GITLAB_PERSONAL_ACCESS_TOKEN" \
  "https://gitlab.com/api/v4/user" | jq '{id, username, name, email, state}'
```
