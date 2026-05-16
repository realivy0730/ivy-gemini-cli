#!/bin/bash

# 配置路徑
SRC_DIR="$HOME/.gemini"
GIT_DIR="$HOME/ivy-gemini-cli"
INCLUDE_FILE="$SRC_DIR/.rsync-include"

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function show_help() {
    echo "Usage: gemini-sync.sh [status|pull|push]"
    echo ""
    echo "Commands:"
    echo "  status  檢查 GitHub 遠端異動狀態"
    echo "  pull    從 GitHub 拉取更新並同步至 ~/.gemini"
    echo "  push    將 ~/.gemini 變更同步至 Git 並推送至 GitHub"
}

function check_status() {
    echo -e "${YELLOW}正在檢查遠端狀態...${NC}"
    cd "$GIT_DIR" || exit
    git fetch origin > /dev/null 2>&1
    
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse @{u} 2>/dev/null)
    
    if [ -z "$REMOTE" ]; then
        echo -e "${RED}錯誤：無法獲取遠端分支資訊。請確保遠端倉儲已建立且有內容。${NC}"
        return
    fi
    
    BASE=$(git merge-base HEAD @{u})

    if [ "$LOCAL" = "$REMOTE" ]; then
        echo -e "${GREEN}狀態：您的配置已是最新。${NC}"
    elif [ "$LOCAL" = "$BASE" ]; then
        echo -e "${RED}狀態：遠端有新的更新！${NC}"
        echo -e "${YELLOW}建議：請執行 'gemini-sync.sh pull' 來更新本地配置。${NC}"
    elif [ "$REMOTE" = "$BASE" ]; then
        echo -e "${YELLOW}狀態：本地有未推送的變更。${NC}"
        echo -e "${YELLOW}建議：請執行 'gemini-sync.sh push' 來備份至 GitHub。${NC}"
    else
        echo -e "${RED}狀態：分支已分叉 (Diverged)！${NC}"
        echo -e "${RED}建議：請手動在 $GIT_DIR 處理衝突。${NC}"
    fi
}

function pull_sync() {
    echo -e "${YELLOW}正在從遠端同步...${NC}"
    cd "$GIT_DIR" || exit
    git pull origin main || git pull origin master
    
    echo -e "${YELLOW}正在將更新套用至 $SRC_DIR ...${NC}"
    rsync -av --exclude='.git' "$GIT_DIR/" "$SRC_DIR/"
    echo -e "${GREEN}同步完成！${NC}"
}

function push_sync() {
    echo -e "${YELLOW}正在準備推送變更...${NC}"
    
    # 使用 rsync 依照白名單同步到 Git 目錄
    echo -e "${YELLOW}同步檔案至 Git 工作區...${NC}"
    rsync -av --delete --include-from="$INCLUDE_FILE" "$SRC_DIR/" "$GIT_DIR/"
    
    cd "$GIT_DIR" || exit
    
    # 檢查是否有變更
    if [ -z "$(git status --porcelain)" ]; then
        echo -e "${GREEN}沒有任何變更需要推送。${NC}"
        return
    fi
    
    git add .
    git commit -m "Auto-sync from ~/.gemini on $(date +'%Y-%m-%d %H:%M:%S')"
    git push origin HEAD
    
    echo -e "${GREEN}已成功推送至 GitHub！${NC}"
}

case "$1" in
    status)
        check_status
        ;;
    pull)
        pull_sync
        ;;
    push)
        push_sync
        ;;
    *)
        show_help
        ;;
esac
