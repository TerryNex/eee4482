# API Configuration Guide

## 配置 API 地址指南 / API Configuration Guide

這個應用程序支持兩種方式來配置 API 地址：服務器端配置文件（推薦用於部署後）和管理員設置頁面。

This application supports two ways to configure the API address: server-side config file (recommended for after deployment) and admin settings page.

---

## 方法一：服務器端配置文件（推薦） / Method 1: Server-Side Config File (Recommended)

### 為什麼使用這個方法？ / Why use this method?

- ✅ **部署後可修改** - 不需要重新編譯和部署應用
- ✅ **適合生產環境** - 在服務器上直接修改配置
- ✅ **防止配置錯誤** - 即使配置錯誤，也可以直接在服務器修正
- ✅ **簡單快速** - 只需編輯一個 JSON 文件

- ✅ **Editable after deployment** - No need to rebuild and redeploy
- ✅ **Perfect for production** - Edit configuration directly on server
- ✅ **Error-proof** - Can fix misconfiguration directly on server
- ✅ **Simple and fast** - Just edit one JSON file

### 步驟 / Steps:

1. **找到配置文件** / **Locate the config file**
   ```
   web/config.json
   ```

2. **編輯配置** / **Edit the configuration**
   
   打開 `web/config.json` 文件，你會看到：
   
   Open `web/config.json` file, you will see:
   
   ```json
   {
     "apiBaseUrl": "http://192.168.50.9/api",
     "useProxy": false,
     "proxyHost": "",
     "proxyPort": 8080,
     "note": "Edit this file on the server to change API configuration without rebuilding the app"
   }
   ```

3. **修改 API 地址** / **Change API URL**
   
   根據你的環境修改 `apiBaseUrl`：
   
   Modify `apiBaseUrl` based on your environment:
   
   **生產環境 (Production):**
   ```json
   {
     "apiBaseUrl": "https://eee4482.chromahk.com/api",
     "useProxy": false,
     "proxyHost": "",
     "proxyPort": 8080
   }
   ```
   
   **遠程開發環境 (Remote Development):**
   ```json
   {
     "apiBaseUrl": "http://192.168.50.9/api",
     "useProxy": false,
     "proxyHost": "",
     "proxyPort": 8080
   }
   ```
   
   **本地開發環境 (Local Development):**
   ```json
   {
     "apiBaseUrl": "http://localhost/api",
     "useProxy": false,
     "proxyHost": "",
     "proxyPort": 8080
   }
   ```

4. **保存並測試** / **Save and test**
   
   - 保存文件 / Save the file
   - 重新加載網頁 / Reload the web page
   - 應用會自動讀取新配置 / App will automatically load new configuration

### 部署後如何修改？ / How to modify after deployment?

如果你已經將應用部署到 PHP 服務器上：

If you have deployed the app to PHP server:

1. SSH 連接到服務器或使用 FTP / SSH to server or use FTP
2. 找到部署目錄下的 `config.json` / Find `config.json` in deployment directory
3. 用文本編輯器打開並修改 / Open with text editor and modify
4. 保存文件 / Save file
5. 清除瀏覽器緩存並刷新頁面 / Clear browser cache and refresh page

**示例路徑 / Example paths:**
- Apache: `/var/www/html/config.json`
- Nginx: `/usr/share/nginx/html/config.json`
- 自定義: `<你的部署目錄>/config.json`

---

## 方法二：管理員設置頁面 / Method 2: Admin Settings Page

### 什麼時候使用？ / When to use?

- 需要臨時切換 API 地址 / Need to temporarily switch API address
- 在瀏覽器中測試不同配置 / Testing different configurations in browser
- 配置會保存在瀏覽器的 localStorage / Config saved in browser's localStorage

### 步驟 / Steps:

1. 以管理員身份登錄 / Login as admin
2. 進入設置頁面 / Go to Settings page
3. 在 "API Configuration" 部分：
   - 方式 A：點擊快速按鈕 / Method A: Click quick buttons
     - **"Production API"** - 使用生產環境 API / Use production API
     - **"Development API"** - 使用開發環境 API / Use development API
   - 方式 B：手動輸入 URL / Method B: Manually enter URL
4. 點擊 "Save Settings" / Click "Save Settings"
5. 刷新頁面測試 / Refresh page to test

### 注意事項 / Notes:

⚠️ **瀏覽器設置優先** - 如果你在設置頁面保存了配置，它會覆蓋 `config.json` 的設置

⚠️ **Browser settings take priority** - If you save config in Settings page, it overrides `config.json`

⚠️ **清除設置** - 要恢復使用 `config.json` 的配置，點擊 "Reset to Defaults"

⚠️ **Clear settings** - To restore `config.json` configuration, click "Reset to Defaults"

---

## 故障排除 / Troubleshooting

### 問題：配置更改後沒有生效 / Issue: Config changes not working

**解決方案 / Solutions:**

1. **清除瀏覽器緩存** / **Clear browser cache**
   - Chrome/Edge: Ctrl+Shift+Delete → 清除緩存 / Clear cache
   - Firefox: Ctrl+Shift+Delete → 清除緩存 / Clear cache

2. **檢查 localStorage** / **Check localStorage**
   - 打開瀏覽器開發者工具 (F12) / Open browser DevTools (F12)
   - Application/Storage → Local Storage
   - 刪除 `api_base_url` 項目 / Delete `api_base_url` item
   - 刷新頁面 / Refresh page

3. **驗證 config.json 格式** / **Verify config.json format**
   - 確保是有效的 JSON 格式 / Ensure valid JSON format
   - 檢查雙引號和逗號 / Check quotes and commas
   - 使用 JSON 驗證工具 / Use JSON validator

4. **檢查文件權限** / **Check file permissions**
   ```bash
   chmod 644 config.json
   ```

### 問題：Mixed Content 錯誤 / Issue: Mixed Content Error

如果你的網站使用 HTTPS 但 API 使用 HTTP，瀏覽器會阻止請求。

If your site uses HTTPS but API uses HTTP, browser will block requests.

**解決方案 / Solutions:**

1. **使用 HTTPS API** (推薦)
   - 配置你的 API 服務器使用 HTTPS
   - 或使用 Cloudflare Tunnel（自動處理 HTTPS）

2. **本地開發使用 HTTP**
   - 在本地開發時，訪問 `http://localhost` 而不是 `https://`

---

## 配置優先級 / Configuration Priority

應用程序按以下順序檢查配置：

The app checks configuration in this order:

1. **瀏覽器 localStorage** (Settings 頁面保存的) / Browser localStorage (saved from Settings page)
2. **服務器 config.json** 文件 / Server config.json file
3. **代碼默認值** (http://192.168.50.9/api) / Code default value

---

## 常見配置場景 / Common Configuration Scenarios

### 場景 1：開發時連接遠程服務器 / Scenario 1: Connect to remote server during development

```json
{
  "apiBaseUrl": "http://192.168.50.9/api"
}
```

### 場景 2：部署到生產環境 / Scenario 2: Deploy to production

```json
{
  "apiBaseUrl": "https://eee4482.chromahk.com/api"
}
```

### 場景 3：使用 Cloudflare Tunnel / Scenario 3: Using Cloudflare Tunnel

```json
{
  "apiBaseUrl": "https://your-tunnel-domain.com/api"
}
```

### 場景 4：本地 PHP 服務器 / Scenario 4: Local PHP server

```json
{
  "apiBaseUrl": "http://localhost/api"
}
```

---

## 需要幫助？ / Need Help?

如果遇到問題，請提供以下信息：

If you encounter issues, please provide:

1. 你的部署環境 / Your deployment environment
2. config.json 的內容 / Content of config.json
3. 瀏覽器控制台錯誤信息 / Browser console error messages
4. 網絡請求的 URL (在開發者工具的 Network 標籤查看) / Network request URL (check in DevTools Network tab)
