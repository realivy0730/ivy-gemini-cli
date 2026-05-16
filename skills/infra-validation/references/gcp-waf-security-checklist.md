# GCP Well-Architected Framework — Security 驗證清單

來源：google/skills google-cloud-waf-security

## Security by Design
- [ ] 系統元件基於安全特性選擇並強化
- [ ] 網路/主機/應用層實施縱深防禦
- [ ] 使用安全函式庫防止常見漏洞
- [ ] 依產業標準執行風險評估

## Zero Trust
- [ ] 存取控制基於身份 + 上下文（裝置、位置）
- [ ] 內部流量使用私有連線（Cloud Interconnect / VPN）
- [ ] 所有專案停用預設網路
- [ ] 敏感資料建立 VPC Service Controls 邊界

## Shift-Left Security
- [ ] 基礎設施用 IaC 佈建（Terraform）
- [ ] CI/CD pipeline 整合自動安全掃描
- [ ] 依賴項漏洞掃描與修補流程
- [ ] Binary Authorization 確保只部署受信任映像

## Preemptive Cyber Defense
- [ ] 威脅情報整合到安全營運
- [ ] 所有關鍵資源啟用集中式安全日誌
- [ ] 常見威脅設定自動回應
- [ ] 定期滲透測試或紅隊演練驗證防禦

## AI Security
- [ ] AI pipeline 防止竄改和資料投毒
- [ ] 訓練資料使用差分隱私或遮蔽
- [ ] 模型治理使用可解釋性和公平性指標
