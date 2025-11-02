# Configuration Guide - EEE4482 e-Library

**Student:** HE HUALIANG (230263367)  
**Course:** EEE 4482 - Server Installation and Programming  
**Version:** 1.2.0  
**Date:** 2025-11-02

---

## Table of Contents

1. [Overview](#overview)
2. [API Configuration](#api-configuration)
3. [Proxy Configuration](#proxy-configuration)
4. [Local Server Settings](#local-server-settings)
5. [Database Setup for Persistent Configuration](#database-setup-for-persistent-configuration)
6. [Configuration Persistence Options](#configuration-persistence-options)
7. [Common Configuration Scenarios](#common-configuration-scenarios)
8. [Troubleshooting](#troubleshooting)

---

## Overview

This guide provides comprehensive instructions for configuring the e-Library application's API settings, proxy settings, and local server parameters. Configuration can be managed through multiple methods:

- **UI-based Configuration** (Settings Page) - For end users
- **Code-based Configuration** (Hardcoded defaults) - For developers
- **Database-based Configuration** (MariaDB/MySQL) - For server-managed deployments

---

## API Configuration

### Method 1: Using the Settings UI (Recommended for Users)

The easiest way to configure API settings is through the application's Settings page:

#### Steps:

1. **Launch the Application**
   - Web: Navigate to your deployment URL
   - Desktop: Launch the application

2. **Navigate to Settings**
   - Click the **gear icon** (⚙️) in the navigation sidebar
   - Or navigate to `/settings` route

3. **Configure API Settings**
   - Locate the **"API Configuration"** section
   - Update the **"API Base URL"** field with your backend server URL
   - Example: `http://192.168.1.100/api/public`

4. **Save Settings**
   - Click the **"Save Settings"** button
   - A success message will appear: "Settings saved successfully"

5. **Verify Configuration**
   - Refresh the page to ensure settings persist
   - Settings are automatically saved to browser local storage (SharedPreferences)

#### Configuration Fields:

| Field | Description | Example |
|-------|-------------|---------|
| **API Base URL** | The root URL of your backend API server | `http://192.168.1.100/api/public` |

---

### Method 2: Code-based Configuration (For Developers)

Developers can set default API configuration in the source code:

#### File Location:
```
lib/config/api_config.dart
```

#### Configuration:

```dart
class ApiConfig {
  // Base API URL - Change this to your server's IP/domain
  static const String baseUrl = 'http://192.168.1.100/api/public';
  
  // Timeout settings (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  
  // API Endpoints (relative to baseUrl)
  static const String getAllBooksEndpoint = '/books';
  static const String addBookEndpoint = '/books/add';
  static const String updateBookEndpoint = '/books/update';
  static const String deleteBookEndpoint = '/books/delete';
}
```

#### To Modify:

1. **Open the File**
   ```bash
   # Using your preferred editor
   code lib/config/api_config.dart
   # or
   nano lib/config/api_config.dart
   ```

2. **Update the Base URL**
   ```dart
   static const String baseUrl = 'http://YOUR_SERVER_IP/api/public';
   ```

3. **Adjust Timeout Settings (Optional)**
   ```dart
   static const int connectionTimeout = 60;  // Increase for slow networks
   static const int receiveTimeout = 60;
   ```

4. **Rebuild the Application**
   ```bash
   flutter clean
   flutter pub get
   flutter build web --release    # For web deployment
   # or
   flutter run -d chrome          # For development
   ```

---

### Method 3: Database-based Configuration (For Server Deployments)

For production environments where settings should be managed centrally:

#### Prerequisites:
- MariaDB or MySQL database installed
- Backend API with database integration

#### Setup:

1. **Import Database Schema**
   ```bash
   mysql -u root -p < database/schema.sql
   ```

2. **Verify Tables Created**
   ```sql
   USE elibrary;
   SHOW TABLES;
   -- Should show: api_settings, proxy_config, user_settings
   ```

3. **View Current Settings**
   ```sql
   SELECT * FROM api_settings;
   ```

4. **Update API Settings**
   ```sql
   -- Update base URL
   CALL update_api_setting('base_url', 'http://192.168.1.100/api/public', 'Base URL for API endpoints');
   
   -- Update timeout
   CALL update_api_setting('connection_timeout', '60', 'Connection timeout in seconds');
   ```

5. **Retrieve Settings via Stored Procedure**
   ```sql
   CALL get_current_api_config();
   ```

---

## Proxy Configuration

### Why Use a Proxy?

Proxy configuration is useful for:
- **CORS Bypass** during development
- **Corporate Networks** requiring HTTP proxy
- **API Debugging** and traffic monitoring
- **Network Testing** with different configurations

---

### Method 1: Using the Settings UI (Recommended)

#### Steps:

1. **Navigate to Settings Page**
   - Click the **gear icon** (⚙️) in the navigation sidebar

2. **Locate Proxy Configuration Section**
   - Scroll to **"Proxy Configuration"**

3. **Enable Proxy**
   - Toggle **"Use Proxy"** switch to ON

4. **Configure Proxy Details**
   - **Proxy Host**: Enter the proxy server hostname or IP
     - Example for local development: `localhost`
     - Example for corporate proxy: `proxy.company.com`
   - **Proxy Port**: Enter the proxy server port
     - Common ports: `8080`, `3128`, `8888`

5. **Save Settings**
   - Click **"Save Settings"** button
   - Success message: "Settings saved successfully"

6. **Test Proxy**
   - Navigate to Book List page
   - If books load successfully, proxy is working

#### Example Configurations:

**Development CORS Proxy:**
```
Use Proxy: ON
Proxy Host: localhost
Proxy Port: 8080
```

**Corporate Proxy:**
```
Use Proxy: ON
Proxy Host: proxy.company.com
Proxy Port: 3128
```

---

### Method 2: Code-based Proxy Configuration

#### File Location:
```
lib/config/api_config.dart
```

#### Configuration:

```dart
class ApiConfig {
  // Proxy settings
  static bool useProxy = false;         // Set to true to enable
  static String proxyHost = '';         // Proxy hostname/IP
  static int proxyPort = 8080;          // Proxy port
}
```

#### To Enable Proxy in Code:

1. **Open Configuration File**
   ```bash
   code lib/config/api_config.dart
   ```

2. **Update Proxy Settings**
   ```dart
   static bool useProxy = true;
   static String proxyHost = 'localhost';
   static int proxyPort = 8080;
   ```

3. **Rebuild Application**
   ```bash
   flutter clean
   flutter pub get
   flutter run -d chrome
   ```

---

### Method 3: Database-based Proxy Configuration

#### Setup Database Proxy Config:

```sql
-- View current proxy configuration
SELECT * FROM proxy_config WHERE is_default = TRUE;

-- Update proxy configuration
CALL update_proxy_config(
    'development',           -- config_name
    TRUE,                    -- enabled
    'localhost',            -- proxy_host
    8080,                   -- proxy_port
    'http'                  -- proxy_type
);

-- Get active proxy configuration
CALL get_current_proxy_config();
```

#### Add New Proxy Configuration:

```sql
INSERT INTO proxy_config 
    (config_name, enabled, proxy_host, proxy_port, proxy_type, description, is_default)
VALUES 
    ('staging', TRUE, 'proxy.staging.com', 3128, 'http', 'Staging environment proxy', TRUE);
```

---

## Local Server Settings

### Modifying Local Development Server

If you're running a local backend API server, here's how to configure it:

### Location: Backend API Configuration

Assuming your backend API is built with PHP (from Worksheet 7b):

#### File Location:
```
/var/www/html/api/config/database.php
or
/path/to/backend/config/database.php
```

#### Typical Configuration:

```php
<?php
// Database Configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'elibrary');
define('DB_USER', 'elibrary_user');
define('DB_PASS', 'your_password');

// API Configuration
define('API_BASE_URL', 'http://192.168.1.100/api/public');
define('CORS_ORIGIN', '*');  // Change to specific domain in production

// Server Configuration
define('SERVER_IP', '192.168.1.100');
define('SERVER_PORT', 80);
?>
```

#### To Modify:

1. **Connect to Your Server**
   ```bash
   ssh username@192.168.1.100
   ```

2. **Navigate to Configuration Directory**
   ```bash
   cd /var/www/html/api/config
   ```

3. **Edit Configuration File**
   ```bash
   sudo nano database.php
   ```

4. **Update Settings**
   - Change `DB_HOST`, `DB_NAME`, `DB_USER`, `DB_PASS` as needed
   - Update `API_BASE_URL` with your server's IP
   - Configure CORS settings

5. **Restart Web Server**
   ```bash
   sudo systemctl restart apache2
   # or
   sudo systemctl restart nginx
   ```

6. **Verify Changes**
   ```bash
   curl http://192.168.1.100/api/public/books
   ```

---

### Apache Virtual Host Configuration

#### File Location:
```
/etc/apache2/sites-available/elibrary.conf
```

#### Configuration:

```apache
<VirtualHost *:80>
    ServerName elibrary.local
    ServerAdmin admin@elibrary.local
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    # CORS Headers for API
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
    
    ErrorLog ${APACHE_LOG_DIR}/elibrary_error.log
    CustomLog ${APACHE_LOG_DIR}/elibrary_access.log combined
</VirtualHost>
```

#### To Modify:

1. **Edit Virtual Host**
   ```bash
   sudo nano /etc/apache2/sites-available/elibrary.conf
   ```

2. **Enable Site**
   ```bash
   sudo a2ensite elibrary
   ```

3. **Enable Headers Module**
   ```bash
   sudo a2enmod headers
   ```

4. **Restart Apache**
   ```bash
   sudo systemctl restart apache2
   ```

---

### Finding Your Local Server IP

#### Linux:
```bash
ip addr show | grep inet
# or
hostname -I
```

#### macOS:
```bash
ifconfig | grep inet
```

#### Windows:
```cmd
ipconfig
```

#### Update Configuration with Your IP:

Once you know your IP address (e.g., `192.168.1.100`):

1. **Update Flutter App**
   - Settings UI: Enter `http://192.168.1.100/api/public`
   - Or update `lib/config/api_config.dart`

2. **Update Backend**
   - Update CORS configuration to allow your IP
   - Update database connection if needed

3. **Test Connection**
   ```bash
   # From client machine
   curl http://192.168.1.100/api/public/books
   ```

---

## Database Setup for Persistent Configuration

### Prerequisites

- MariaDB or MySQL installed
- Database user with appropriate privileges

### Installation Steps

#### 1. Install MariaDB (if not already installed)

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation
```

**CentOS/RHEL:**
```bash
sudo yum install mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation
```

#### 2. Create Database and User

```bash
# Login to MySQL
sudo mysql -u root -p
```

```sql
-- Create database
CREATE DATABASE elibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user
CREATE USER 'elibrary_user'@'localhost' IDENTIFIED BY 'your_secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON elibrary.* TO 'elibrary_user'@'localhost';

-- For remote access (adjust IP as needed)
CREATE USER 'elibrary_user'@'%' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON elibrary.* TO 'elibrary_user'@'%';

FLUSH PRIVILEGES;
EXIT;
```

#### 3. Import Schema

```bash
# Import the schema
mysql -u elibrary_user -p elibrary < database/schema.sql

# Verify tables were created
mysql -u elibrary_user -p elibrary -e "SHOW TABLES;"
```

#### 4. Verify Data

```bash
mysql -u elibrary_user -p elibrary
```

```sql
-- Check API settings
SELECT * FROM api_settings;

-- Check proxy configurations
SELECT * FROM proxy_config;

-- Test stored procedures
CALL get_current_api_config();
CALL get_current_proxy_config();
```

---

## Configuration Persistence Options

The e-Library application supports multiple configuration persistence methods:

### 1. Local Browser Storage (Default)

**Technology:** SharedPreferences (Web: LocalStorage, Desktop: Platform-specific)

**Pros:**
- ✅ No server-side setup required
- ✅ Works offline
- ✅ User-specific settings
- ✅ Instant persistence

**Cons:**
- ❌ Settings lost if browser data cleared
- ❌ Not shared across devices
- ❌ Cannot be centrally managed

**Use Case:** Single-user desktop applications, personal web usage

---

### 2. Database Persistence (Server-managed)

**Technology:** MariaDB/MySQL with stored procedures

**Pros:**
- ✅ Centralized configuration management
- ✅ Shared across all users/devices
- ✅ Can be backed up
- ✅ Version controlled
- ✅ Admin-managed

**Cons:**
- ❌ Requires database setup
- ❌ Backend API integration needed
- ❌ More complex deployment

**Use Case:** Multi-user enterprise deployments, centrally managed configurations

---

### 3. Hybrid Approach (Recommended for Production)

**Strategy:** Use both local storage and database

**Flow:**
1. Application loads with hardcoded defaults
2. Fetches configuration from database (if available)
3. User can override via Settings UI
4. User overrides saved to local storage
5. Admin changes to database affect all users

**Implementation:**
- Frontend: Check local storage first, fallback to API
- Backend: Provide API endpoints for config retrieval/update
- Database: Store system-wide defaults and user overrides

---

## Common Configuration Scenarios

### Scenario 1: Development Environment

**Goal:** Local development with CORS proxy

**Configuration:**
```dart
// lib/config/api_config.dart
static const String baseUrl = 'http://localhost:3000/api';
static bool useProxy = true;
static String proxyHost = 'localhost';
static int proxyPort = 8080;
```

**Proxy Setup:**
```bash
# Install cors-anywhere (Node.js)
npm install -g cors-anywhere

# Run proxy server
cors-anywhere
```

---

### Scenario 2: Local Network Testing

**Goal:** Test on local network with other devices

**Configuration:**
1. **Find Your IP Address**
   ```bash
   hostname -I
   # Example: 192.168.1.100
   ```

2. **Update Flutter App**
   - Settings UI: `http://192.168.1.100/api/public`
   - Or hardcode in `api_config.dart`

3. **Configure Backend CORS**
   ```php
   // Allow specific IP or subnet
   header('Access-Control-Allow-Origin: http://192.168.1.*');
   ```

4. **Test from Another Device**
   - Connect to same network
   - Navigate to: `http://192.168.1.100`

---

### Scenario 3: Production Deployment

**Goal:** Secure, scalable production environment

**Configuration:**
1. **Use HTTPS**
   ```dart
   static const String baseUrl = 'https://api.yourdomain.com';
   ```

2. **Disable Proxy**
   ```dart
   static bool useProxy = false;
   ```

3. **Database Configuration**
   ```sql
   CALL update_api_setting('base_url', 'https://api.yourdomain.com', 'Production API URL');
   ```

4. **Secure Backend**
   - Enable HTTPS with SSL certificate
   - Configure proper CORS headers
   - Implement authentication

---

### Scenario 4: Corporate Network with Proxy

**Goal:** Access external API through corporate proxy

**Configuration:**
1. **Enable Proxy in Settings UI**
   ```
   Use Proxy: ON
   Proxy Host: proxy.company.com
   Proxy Port: 3128
   ```

2. **Or Use Database Config**
   ```sql
   CALL update_proxy_config('corporate', TRUE, 'proxy.company.com', 3128, 'http');
   ```

3. **Test Connection**
   - Try loading book list
   - Check browser console for errors

---

## Troubleshooting

### Issue 1: Settings Don't Persist After Refresh

**Symptoms:**
- Save settings successfully
- Refresh page
- Settings revert to defaults

**Possible Causes:**
1. Browser blocking local storage
2. Incognito/private mode enabled
3. SharedPreferences not initializing properly

**Solutions:**

1. **Check Browser Settings**
   - Chrome: Settings → Privacy → Cookies and site data
   - Enable "Allow all cookies"

2. **Disable Private Mode**
   - Use normal browser window instead of incognito

3. **Clear Browser Cache**
   ```
   Chrome: Ctrl+Shift+Delete → Clear browsing data
   ```

4. **Check Console for Errors**
   - Open DevTools (F12)
   - Look for SharedPreferences errors
   - Check for permission issues

5. **Verify SharedPreferences Package**
   ```bash
   flutter pub get
   flutter clean
   flutter run
   ```

---

### Issue 2: API Connection Fails

**Symptoms:**
- "Network error: Unable to connect to server"
- Timeout errors
- No data loading

**Solutions:**

1. **Verify API URL**
   - Check Settings page: Is URL correct?
   - Try accessing URL in browser: `http://192.168.1.100/api/public/books`

2. **Check Server Status**
   ```bash
   # On server
   sudo systemctl status apache2
   # or
   sudo systemctl status nginx
   ```

3. **Test API Directly**
   ```bash
   curl http://192.168.1.100/api/public/books
   ```

4. **Check Firewall**
   ```bash
   sudo ufw status
   sudo ufw allow 80/tcp
   ```

5. **Review CORS Configuration**
   - Backend should send proper CORS headers
   - Check browser console for CORS errors

---

### Issue 3: Proxy Not Working

**Symptoms:**
- Proxy enabled but connection still fails
- CORS errors persist

**Solutions:**

1. **Verify Proxy Server Running**
   ```bash
   # Check if proxy is listening
   netstat -tuln | grep 8080
   ```

2. **Test Proxy Directly**
   ```bash
   curl -x http://localhost:8080 http://192.168.1.100/api/public/books
   ```

3. **Check Proxy Logs**
   - Review proxy server logs for errors
   - Verify proxy is forwarding requests

4. **Try Different Proxy Port**
   - Common alternatives: 3128, 8888, 8000

5. **Disable Proxy Temporarily**
   - Test without proxy to isolate issue
   - If works without proxy, problem is proxy configuration

---

### Issue 4: Database Connection Issues

**Symptoms:**
- Cannot connect to MariaDB
- Stored procedures not working

**Solutions:**

1. **Verify Database Running**
   ```bash
   sudo systemctl status mariadb
   ```

2. **Test Database Connection**
   ```bash
   mysql -u elibrary_user -p elibrary
   ```

3. **Check User Privileges**
   ```sql
   SHOW GRANTS FOR 'elibrary_user'@'localhost';
   ```

4. **Verify Tables Exist**
   ```sql
   USE elibrary;
   SHOW TABLES;
   ```

5. **Check Error Logs**
   ```bash
   sudo tail -f /var/log/mysql/error.log
   ```

---

### Issue 5: Configuration Changes Not Taking Effect

**Symptoms:**
- Update settings
- Save successfully
- Application still uses old values

**Solutions:**

1. **Hard Refresh Browser**
   - Chrome/Firefox: Ctrl+Shift+R (Windows/Linux)
   - Chrome/Firefox: Cmd+Shift+R (macOS)

2. **Check Network Tab**
   - Open DevTools → Network
   - Look for API calls using old URL
   - Verify request headers

3. **Restart Application**
   - Stop app: `q` in terminal
   - Restart: `flutter run`

4. **Clear Build Cache**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

5. **Check Provider Initialization**
   - Verify `SettingsProvider` is initialized in `main.dart`
   - Ensure provider listeners are working

---

## Additional Resources

### Documentation
- [API & Proxy Guide](API_PROXY_VALIDATION_GUIDE.md)
- [README.md](../README.md)
- [Deployment Guide](../DEPLOYMENT.md)

### Database
- MariaDB Documentation: https://mariadb.org/documentation/
- MySQL Documentation: https://dev.mysql.com/doc/

### Flutter
- SharedPreferences Package: https://pub.dev/packages/shared_preferences
- Provider Package: https://pub.dev/packages/provider

---

## Summary

This guide covered three methods for configuring the e-Library application:

1. **UI-based Configuration** - Settings page for end users
2. **Code-based Configuration** - `lib/config/api_config.dart` for developers
3. **Database Configuration** - MariaDB/MySQL for server-managed deployments

**Recommended Approach:**
- **Development:** UI or code-based configuration
- **Production:** Database-based with UI override option
- **Enterprise:** Hybrid approach with centralized database and local overrides

For additional help, refer to the troubleshooting section or contact the course instructor.

---

**Last Updated:** 2025-11-02  
**Student:** HE HUALIANG (230263367)  
**Course:** EEE 4482 - Server Installation and Programming
