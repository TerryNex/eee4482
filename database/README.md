# Database Schema - EEE4482 e-Library

**Student:** HE HUALIANG (230263367)  
**Purpose:** Persistent configuration storage for API and Proxy settings  
**Database:** MariaDB / MySQL

---

## Overview

This directory contains database schema and example SQL scripts for storing persistent configuration in the e-Library application. The database persistence feature is optional and complements the default local storage (SharedPreferences) mechanism.

---

## Files

### 1. schema.sql

**Purpose:** Complete database schema including tables, views, and stored procedures

**Contents:**
- **Tables:**
  - `api_settings` - API configuration (base URL, timeouts, auth tokens)
  - `proxy_config` - Proxy configurations (host, port, type)
  - `user_settings` - User-specific preferences (theme, language)

- **Views:**
  - `active_api_settings` - Currently active API settings
  - `active_proxy_config` - Currently active proxy configuration

- **Stored Procedures:**
  - `update_api_setting` - Update or insert API setting
  - `update_proxy_config` - Update proxy configuration
  - `get_current_api_config` - Get API config as JSON
  - `get_current_proxy_config` - Get proxy config as JSON

### 2. examples.sql

**Purpose:** Common configuration scenarios and SQL examples

**Contents:**
- Update API base URLs (development, production, local)
- Configure timeout settings
- Enable/disable authentication
- Setup proxy configurations
- Query current configuration
- User-specific settings
- Backup and restore examples
- Monitoring and auditing queries

---

## Quick Start

### Prerequisites

- MariaDB 10.3+ or MySQL 5.7+
- Database user with appropriate privileges
- Command-line access to database server

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
# Login as root
sudo mysql -u root -p
```

```sql
-- Create database
CREATE DATABASE elibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (change password!)
CREATE USER 'elibrary_user'@'localhost' IDENTIFIED BY 'your_secure_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON elibrary.* TO 'elibrary_user'@'localhost';

FLUSH PRIVILEGES;
EXIT;
```

#### 3. Import Schema

```bash
# Import the schema
mysql -u elibrary_user -p elibrary < schema.sql

# Verify tables
mysql -u elibrary_user -p elibrary -e "SHOW TABLES;"
```

Expected output:
```
+--------------------+
| Tables_in_elibrary |
+--------------------+
| api_settings       |
| proxy_config       |
| user_settings      |
+--------------------+
```

#### 4. Verify Installation

```bash
mysql -u elibrary_user -p elibrary
```

```sql
-- Check default API settings
SELECT * FROM api_settings;

-- Check default proxy configurations
SELECT * FROM proxy_config;

-- Test stored procedures
CALL get_current_api_config();
CALL get_current_proxy_config();
```

---

## Usage Examples

### Update API Base URL

```sql
USE elibrary;

-- For development
CALL update_api_setting('base_url', 'http://localhost:3000/api', 'Development API');

-- For production
CALL update_api_setting('base_url', 'https://api.elibrary.com', 'Production API');

-- For local network
CALL update_api_setting('base_url', 'http://192.168.1.100/api/public', 'Local API');
```

### Configure Proxy

```sql
-- Enable development proxy
CALL update_proxy_config('development', TRUE, 'localhost', 8080, 'http');

-- Enable corporate proxy
CALL update_proxy_config('corporate', TRUE, 'proxy.company.com', 3128, 'http');

-- Disable proxy
CALL update_proxy_config('default', FALSE, 'localhost', 8080, 'http');
```

### Query Current Configuration

```sql
-- Get all active API settings
SELECT * FROM active_api_settings;

-- Get active proxy configuration
SELECT * FROM active_proxy_config;

-- Get API configuration as JSON
CALL get_current_api_config();

-- Get proxy configuration as JSON
CALL get_current_proxy_config();
```

### User-Specific Settings

```sql
-- Set user theme (user_id = 1)
INSERT INTO user_settings (user_id, setting_key, setting_value)
VALUES (1, 'theme', 'githubHighContrast')
ON DUPLICATE KEY UPDATE setting_value = 'githubHighContrast';

-- Get user settings
SELECT setting_key, setting_value FROM user_settings WHERE user_id = 1;
```

---

## Database Schema Details

### Table: api_settings

Stores API configuration parameters.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| setting_key | VARCHAR(100) | Setting name (e.g., 'base_url') |
| setting_value | TEXT | Setting value |
| description | TEXT | Setting description |
| is_active | BOOLEAN | Whether setting is active |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

**Default Settings:**
- `base_url`: http://192.168.1.100/api/public
- `connection_timeout`: 30
- `receive_timeout`: 30
- `auth_enabled`: false
- `auth_token`: (empty)

### Table: proxy_config

Stores proxy configuration profiles.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| config_name | VARCHAR(100) | Configuration name |
| enabled | BOOLEAN | Whether proxy is enabled |
| proxy_host | VARCHAR(255) | Proxy hostname or IP |
| proxy_port | INT | Proxy port (1-65535) |
| proxy_type | ENUM | Proxy type (http, https, socks5) |
| username | VARCHAR(100) | Proxy auth username |
| password | VARCHAR(255) | Proxy auth password (encrypted) |
| description | TEXT | Configuration description |
| is_default | BOOLEAN | Whether this is default config |
| is_active | BOOLEAN | Whether config is active |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

**Default Configurations:**
- `default`: Disabled, localhost:8080
- `development`: Disabled, localhost:8080
- `corporate`: Disabled, proxy.company.com:3128

### Table: user_settings

Stores user-specific preferences.

| Column | Type | Description |
|--------|------|-------------|
| id | INT | Primary key |
| user_id | INT | User identifier |
| setting_key | VARCHAR(100) | Setting name (e.g., 'theme') |
| setting_value | TEXT | Setting value |
| created_at | TIMESTAMP | Creation timestamp |
| updated_at | TIMESTAMP | Last update timestamp |

---

## Stored Procedures

### update_api_setting

Update or insert an API setting.

```sql
CALL update_api_setting(
    'base_url',                        -- setting key
    'http://192.168.1.100/api/public', -- setting value
    'API Base URL'                      -- description
);
```

### update_proxy_config

Update proxy configuration.

```sql
CALL update_proxy_config(
    'development',  -- config_name
    TRUE,          -- enabled
    'localhost',   -- proxy_host
    8080,          -- proxy_port
    'http'         -- proxy_type
);
```

### get_current_api_config

Get current API configuration as JSON.

```sql
CALL get_current_api_config();
```

Returns:
```json
{
  "baseUrl": "http://192.168.1.100/api/public",
  "connectionTimeout": 30,
  "receiveTimeout": 30,
  "authEnabled": false,
  "authToken": ""
}
```

### get_current_proxy_config

Get current proxy configuration as JSON.

```sql
CALL get_current_proxy_config();
```

Returns:
```json
{
  "configName": "development",
  "enabled": true,
  "proxyHost": "localhost",
  "proxyPort": 8080,
  "proxyType": "http",
  "username": null,
  "description": "Development CORS proxy"
}
```

---

## Backend API Integration

To integrate the database configuration with your backend API, you'll need to create endpoints that:

1. **Fetch Configuration** - Read from database and return to frontend
2. **Update Configuration** - Accept updates from frontend and save to database

### Example PHP API Endpoints

#### GET /api/config

```php
<?php
// Fetch API configuration
$stmt = $pdo->query("CALL get_current_api_config()");
$config = $stmt->fetch(PDO::FETCH_ASSOC);
echo json_encode($config);
?>
```

#### POST /api/config/api

```php
<?php
// Update API configuration
$data = json_decode(file_get_contents('php://input'), true);

$stmt = $pdo->prepare("CALL update_api_setting(?, ?, ?)");
$stmt->execute([
    'base_url',
    $data['baseUrl'],
    'API Base URL'
]);

echo json_encode(['success' => true]);
?>
```

#### GET /api/config/proxy

```php
<?php
// Fetch proxy configuration
$stmt = $pdo->query("CALL get_current_proxy_config()");
$config = $stmt->fetch(PDO::FETCH_ASSOC);
echo json_encode($config);
?>
```

#### POST /api/config/proxy

```php
<?php
// Update proxy configuration
$data = json_decode(file_get_contents('php://input'), true);

$stmt = $pdo->prepare("CALL update_proxy_config(?, ?, ?, ?, ?)");
$stmt->execute([
    $data['configName'] ?? 'default',
    $data['enabled'] ?? false,
    $data['proxyHost'],
    $data['proxyPort'],
    $data['proxyType'] ?? 'http'
]);

echo json_encode(['success' => true]);
?>
```

---

## Backup and Restore

### Backup Database

```bash
# Backup entire database
mysqldump -u elibrary_user -p elibrary > elibrary_backup.sql

# Backup only configuration tables
mysqldump -u elibrary_user -p elibrary api_settings proxy_config user_settings > config_backup.sql

# Backup with timestamp
mysqldump -u elibrary_user -p elibrary > elibrary_backup_$(date +%Y%m%d_%H%M%S).sql
```

### Restore Database

```bash
# Restore from backup
mysql -u elibrary_user -p elibrary < elibrary_backup.sql

# Restore only configuration tables
mysql -u elibrary_user -p elibrary < config_backup.sql
```

---

## Security Considerations

### Password Encryption

For proxy configurations with authentication, passwords should be encrypted:

```sql
-- Using AES encryption (example)
UPDATE proxy_config 
SET password = AES_ENCRYPT('plain_password', 'encryption_key')
WHERE config_name = 'corporate';

-- Decrypt when retrieving
SELECT 
    config_name,
    AES_DECRYPT(password, 'encryption_key') AS decrypted_password
FROM proxy_config;
```

### User Privileges

Grant minimal required privileges:

```sql
-- Read-only user
CREATE USER 'elibrary_readonly'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT ON elibrary.* TO 'elibrary_readonly'@'localhost';

-- Read-write for application
CREATE USER 'elibrary_app'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE ON elibrary.* TO 'elibrary_app'@'localhost';
GRANT EXECUTE ON PROCEDURE elibrary.update_api_setting TO 'elibrary_app'@'localhost';
GRANT EXECUTE ON PROCEDURE elibrary.update_proxy_config TO 'elibrary_app'@'localhost';

FLUSH PRIVILEGES;
```

### Remote Access

For production deployments, restrict remote access:

```sql
-- Allow specific IP only
CREATE USER 'elibrary_user'@'192.168.1.100' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE ON elibrary.* TO 'elibrary_user'@'192.168.1.100';
FLUSH PRIVILEGES;
```

---

## Monitoring and Maintenance

### Check Configuration Changes

```sql
-- Recent API setting changes
SELECT 
    setting_key,
    setting_value,
    updated_at,
    TIMESTAMPDIFF(MINUTE, updated_at, NOW()) AS minutes_ago
FROM api_settings
WHERE updated_at > DATE_SUB(NOW(), INTERVAL 24 HOUR)
ORDER BY updated_at DESC;

-- Proxy configuration history
SELECT 
    config_name,
    enabled,
    updated_at
FROM proxy_config
ORDER BY updated_at DESC;
```

### Database Size

```sql
-- Check table sizes
SELECT 
    TABLE_NAME,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS Size_MB
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'elibrary'
ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;
```

### Optimize Tables

```sql
-- Optimize all tables
OPTIMIZE TABLE api_settings;
OPTIMIZE TABLE proxy_config;
OPTIMIZE TABLE user_settings;
```

---

## Troubleshooting

### Issue: Cannot connect to database

**Solution:**
```bash
# Check if MariaDB is running
sudo systemctl status mariadb

# Start if not running
sudo systemctl start mariadb

# Check error log
sudo tail -f /var/log/mysql/error.log
```

### Issue: Permission denied

**Solution:**
```sql
-- Check user privileges
SHOW GRANTS FOR 'elibrary_user'@'localhost';

-- Re-grant if needed
GRANT ALL PRIVILEGES ON elibrary.* TO 'elibrary_user'@'localhost';
FLUSH PRIVILEGES;
```

### Issue: Stored procedure not found

**Solution:**
```bash
# Re-import schema
mysql -u elibrary_user -p elibrary < schema.sql

# Verify procedures exist
mysql -u elibrary_user -p elibrary -e "SHOW PROCEDURE STATUS WHERE Db = 'elibrary';"
```

---

## Additional Resources

- [Configuration Guide](../docs/CONFIGURATION_GUIDE.md) - Complete configuration instructions
- [API Documentation](../docs/API_PROXY_VALIDATION_GUIDE.md) - API usage guide
- [Main README](../README.md) - Project overview and setup
- MariaDB Documentation: https://mariadb.org/documentation/
- MySQL Documentation: https://dev.mysql.com/doc/

---

**Last Updated:** 2025-11-02  
**Student:** HE HUALIANG (230263367)  
**Course:** EEE 4482 - Server Installation and Programming
