#!/bin/bash
# ~/.kiro/scripts/context-scanner.sh
# 用途：提取當前工作目錄的結構化上下文，供 AI 快速掌握專案現況。

set -uo pipefail

PROJECT_ROOT=$(pwd)
LOCAL_KIRO="$PROJECT_ROOT/.kiro"
LOCAL_DOCS="$PROJECT_ROOT/docs"

echo "### [Project Scan: $(basename "$PROJECT_ROOT")]"

# 1. 掃描 .kiro 配置
if [ -d "$LOCAL_KIRO" ]; then
    echo -e "\n- **專案級配置**: 偵測到 .kiro 目錄"
    [ -f "$LOCAL_KIRO/steering/project-rules.md" ] && echo "  - 載入專案規則: project-rules.md"
    ls "$LOCAL_KIRO/skills" 2>/dev/null | xargs -I {} echo "  - 專案技能: {}"
fi

# 2. 掃描文件結構 (docs/)
if [ -d "$LOCAL_DOCS" ]; then
    echo -e "\n- **文件結構 (docs/)**:"
    tree -L 2 "$LOCAL_DOCS" 2>/dev/null || find "$LOCAL_DOCS" -maxdepth 2
fi

# 3. 提取當前任務 (CHANGELOG [Unreleased])
if [ -f "$PROJECT_ROOT/CHANGELOG.md" ]; then
    echo -e "\n- **當前任務 (Backlog)**:"
    sed -n '/## \[Unreleased\]/,/## \[/p' "$PROJECT_ROOT/CHANGELOG.md" | grep -v "## \[" | grep -E "^- " | head -n 10
fi

# 4. 偵測技術棧
echo -e "\n- **技術棧偵測**:"
[ -f "package.json" ] && echo "  - Node.js (package.json)"
[ -f "requirements.txt" ] && echo "  - Python (requirements.txt)"
[ -f "main.tf" ] || ls *.tf &>/dev/null && echo "  - Terraform (IaC)"
[ -f "docker-compose.yml" ] && echo "  - Docker (Containerized)"
