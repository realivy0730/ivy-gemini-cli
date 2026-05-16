---
name: frontend-ui-engineering
description: "打造可存取、效能好、視覺精緻的 production 等級 UI。Use when building or modifying user-facing interfaces, components, layouts, or state management."
---

# Frontend UI Engineering

## 架構描述
Production 等級的前端 UI 開發方法論，涵蓋 component 設計、accessibility、效能優化與視覺品質。

## 觸發方式
- 「建構 UI」「修改介面」「前端開發」
- 處理 component、layout、CSS、狀態管理時

## 執行流程

### 1. Design System 對齊
- 確認專案的 design tokens（色彩、字型、間距）
- 遵循既有 component library 規範

### 2. Component 設計原則
- 單一職責：每個 component 只做一件事
- Props 介面清晰：必要 props 明確，可選 props 有預設值
- 可組合性：小 component 組合成大 component

### 3. Accessibility（a11y）
- 語義化 HTML（button 不用 div）
- ARIA 屬性正確使用
- 鍵盤導航支援
- 色彩對比度 ≥ 4.5:1

### 4. 效能
- 圖片 lazy loading
- Code splitting / 動態 import
- 避免不必要的 re-render
- Core Web Vitals 達標

### 5. 視覺品質
- 響應式設計（mobile-first）
- 動畫流暢（60fps）
- 載入狀態、空狀態、錯誤狀態都要處理

## 驗收標準
- [ ] 通過 accessibility 檢查
- [ ] 響應式在 mobile/tablet/desktop 正常
- [ ] 無 console error
- [ ] Core Web Vitals 達標
