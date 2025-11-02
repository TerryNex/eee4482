# Migration Guide: V1.1 to V1.2

**Student:** HE HUALIANG (230263367)  
**Course:** EEE 4482 - Server Installation and Programming  
**Date:** 2025-11-02

---

## Overview

This guide helps you migrate from Version 1.1 to Version 1.2 of the e-Library application. Version 1.2 introduces optional database persistence for API and proxy configurations, while maintaining full backward compatibility with V1.1.

**Important:** This is an **optional upgrade**. Your existing V1.1 installation will continue to work without any changes. The database persistence feature is an enhancement for server-managed, multi-user deployments.

---

## What's New in V1.2?

### New Features

1. **Database Persistence** (Optional)
   - Store API and proxy configurations in MariaDB/MySQL
   - Centralized configuration management
   - Multi-user configuration sharing
   - Backup and restore capabilities

2. **Enhanced Documentation**
   - Comprehensive Configuration Guide (937 lines)
   - Database setup and integration guide
   - SQL examples for common scenarios
   - Troubleshooting and best practices

3. **Better Security**
   - .gitignore entries for sensitive files
   - Password encryption examples
   - User privilege management

---

## Do You Need to Upgrade?

### Keep V1.1 (Local Storage Only) If:

- ✅ Single-user installation
- ✅ Desktop application deployment
- ✅ No need for centralized configuration
- ✅ Offline usage required
- ✅ Simple deployment preferred

**No action required!** Your existing settings will continue to work.

### Upgrade to V1.2 (With Database) If:

- ✅ Multi-user deployment
- ✅ Centralized configuration management needed
- ✅ Configuration backup/restore required
- ✅ Server-managed environment
- ✅ Multiple instances sharing same config

---

## Migration Steps

### Option 1: Continue Using V1.1 (No Changes)

**What to do:** Nothing! Your installation continues to work as-is.

**Settings storage:** Browser local storage (SharedPreferences)

**Pros:**
- No setup required
- Works offline
- User-specific settings

**Cons:**
- Settings lost if browser data cleared
- Not shared across devices
- Cannot be centrally managed

---

### Option 2: Upgrade to V1.2 with Database Persistence

#### Prerequisites

Before starting, ensure you have:
- MariaDB 10.3+ or MySQL 5.7+ installed
- Database admin access
- PHP backend API (if using database persistence)
- Basic SQL knowledge

#### Step 1: Update Application Files

```bash
# Pull latest changes
git pull origin main

# Or download the latest release
# https://github.com/TerryNex/eee4482/releases
```

No code changes required! The database schema is an optional add-on.

#### Step 2: Install Database (Optional)

##### 2.1 Install MariaDB

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

##### 2.2 Create Database and User

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

##### 2.3 Import Schema

```bash
# From repository root
cd /path/to/eee4482

# Import schema
mysql -u elibrary_user -p elibrary < database/schema.sql

# Verify
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

#### Step 3: Migrate Existing Settings (Optional)

If you want to migrate your existing settings to the database:

##### 3.1 Export Current Settings

From your browser console (F12):
```javascript
// Get current settings
console.log('API URL:', localStorage.getItem('flutter.api_base_url'));
console.log('Use Proxy:', localStorage.getItem('flutter.use_proxy'));
console.log('Proxy Host:', localStorage.getItem('flutter.proxy_host'));
console.log('Proxy Port:', localStorage.getItem('flutter.proxy_port'));
console.log('Theme:', localStorage.getItem('flutter.theme'));
```

##### 3.2 Import to Database

```bash
mysql -u elibrary_user -p elibrary
```

```sql
-- Import API settings
CALL update_api_setting('base_url', 'YOUR_API_URL_HERE', 'Migrated from V1.1');

-- Import proxy settings (if enabled)
CALL update_proxy_config(
    'migrated',                  -- config_name
    TRUE,                        -- enabled (adjust as needed)
    'YOUR_PROXY_HOST',          -- proxy_host
    YOUR_PROXY_PORT,            -- proxy_port (number)
    'http'                      -- proxy_type
);

-- Import user theme (user_id = 1)
INSERT INTO user_settings (user_id, setting_key, setting_value)
VALUES (1, 'theme', 'YOUR_THEME_HERE')
ON DUPLICATE KEY UPDATE setting_value = 'YOUR_THEME_HERE';
```

#### Step 4: Configure Backend API (Optional)

To use database-based configuration, you need API endpoints:

##### 4.1 Create PHP Endpoints

**File:** `api/config.php`
```php
<?php
require_once 'config/database.php';

// Get API configuration
if ($_SERVER['REQUEST_METHOD'] === 'GET' && $_GET['type'] === 'api') {
    $stmt = $pdo->query("CALL get_current_api_config()");
    $config = $stmt->fetch(PDO::FETCH_ASSOC);
    echo json_encode($config);
}

// Get proxy configuration
if ($_SERVER['REQUEST_METHOD'] === 'GET' && $_GET['type'] === 'proxy') {
    $stmt = $pdo->query("CALL get_current_proxy_config()");
    $config = $stmt->fetch(PDO::FETCH_ASSOC);
    echo json_encode($config);
}

// Update API configuration
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_POST['type'] === 'api') {
    $stmt = $pdo->prepare("CALL update_api_setting(?, ?, ?)");
    $stmt->execute([
        $_POST['key'],
        $_POST['value'],
        $_POST['description'] ?? ''
    ]);
    echo json_encode(['success' => true]);
}

// Update proxy configuration
if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_POST['type'] === 'proxy') {
    $stmt = $pdo->prepare("CALL update_proxy_config(?, ?, ?, ?, ?)");
    $stmt->execute([
        $_POST['configName'] ?? 'default',
        $_POST['enabled'] ?? false,
        $_POST['proxyHost'],
        $_POST['proxyPort'],
        $_POST['proxyType'] ?? 'http'
    ]);
    echo json_encode(['success' => true]);
}
?>
```

#### Step 5: Test Configuration

##### 5.1 Test Database Connection

```bash
mysql -u elibrary_user -p elibrary
```

```sql
-- Verify tables
SHOW TABLES;

-- Check API settings
SELECT * FROM api_settings;

-- Check proxy config
SELECT * FROM proxy_config;

-- Test stored procedures
CALL get_current_api_config();
CALL get_current_proxy_config();
```

##### 5.2 Test Application

1. **Launch the application**
   ```bash
   flutter run -d chrome
   ```

2. **Navigate to Settings page**
   - Click gear icon (⚙️)

3. **Verify settings persist**
   - Change API URL
   - Click "Save Settings"
   - Refresh page
   - Verify settings remain

##### 5.3 Test Backend API (if configured)

```bash
# Test fetch config
curl http://your-server/api/config.php?type=api

# Test fetch proxy
curl http://your-server/api/config.php?type=proxy
```

---

## Rollback Plan

If you encounter issues, you can easily roll back:

### Rollback to V1.1

```bash
# Revert to V1.1 commit
git checkout v1.1

# Or simply delete database
mysql -u root -p -e "DROP DATABASE elibrary;"
```

**Important:** Your local storage settings are not affected by database operations. The app will continue to use SharedPreferences if database is unavailable.

---

## Backward Compatibility

V1.2 is **fully backward compatible** with V1.1:

- ✅ Existing settings in local storage continue to work
- ✅ No code changes required in Flutter app
- ✅ Database is optional, not required
- ✅ UI and functionality remain the same
- ✅ All V1.1 features work unchanged

---

## Configuration Priority

If both local storage and database are available, the priority is:

1. **User overrides** (local storage) - Highest priority
2. **Database settings** (if available)
3. **Hardcoded defaults** (code) - Fallback

This allows users to override system defaults with personal preferences.

---

## Troubleshooting

### Issue: Settings don't persist after upgrade

**Solution:**
- Check browser allows local storage
- Verify not in incognito mode
- Clear cache and try again

### Issue: Database connection fails

**Solution:**
```bash
# Check MariaDB status
sudo systemctl status mariadb

# Check error logs
sudo tail -f /var/log/mysql/error.log

# Test connection
mysql -u elibrary_user -p elibrary
```

### Issue: Stored procedures not found

**Solution:**
```bash
# Re-import schema
mysql -u elibrary_user -p elibrary < database/schema.sql

# Verify procedures
mysql -u elibrary_user -p elibrary -e "SHOW PROCEDURE STATUS WHERE Db = 'elibrary';"
```

### Issue: API endpoints not working

**Solution:**
- Verify PHP backend is running
- Check API endpoint URLs
- Review web server logs
- Test with curl/Postman first

---

## Performance Considerations

### Local Storage (V1.1)

- ⚡ Instant read/write
- 💾 ~10MB storage limit
- 🔒 Client-side only

### Database (V1.2)

- ⚡ Network latency (typically <100ms)
- 💾 Unlimited storage
- 🔒 Server-side with backup

**Recommendation:** For best performance, continue using local storage for user preferences and use database only for system-wide defaults.

---

## Security Notes

### V1.1 Security

- Settings stored in browser local storage
- Client-side only
- User-specific

### V1.2 Security Enhancements

- Database passwords can be encrypted
- User privileges can be restricted
- Audit trail in database
- Centralized security management

**Important:** Update `.gitignore` to prevent committing sensitive data:
```
database/*.backup
database/*_backup.sql
*.env
```

---

## Documentation Updates

New documentation available in V1.2:

1. **[Configuration Guide](CONFIGURATION_GUIDE.md)**
   - 937 lines of comprehensive instructions
   - Three configuration methods
   - Database setup guide
   - Common scenarios and examples

2. **[Database README](../database/README.md)**
   - Quick start guide
   - Schema documentation
   - Backend integration examples
   - Security best practices

3. **[SQL Examples](../database/examples.sql)**
   - 17 common configuration scenarios
   - Backup/restore procedures
   - Query examples

4. **Updated [README.md](../README.md)**
   - Configuration persistence section
   - Links to all new documentation

---

## Support

For help with migration:

1. **Read Documentation**
   - [Configuration Guide](CONFIGURATION_GUIDE.md)
   - [Database README](../database/README.md)

2. **Check Examples**
   - [SQL Examples](../database/examples.sql)

3. **Report Issues**
   - GitHub Issues: https://github.com/TerryNex/eee4482/issues

4. **Contact**
   - Student: HE HUALIANG (230263367)
   - Course: EEE 4482

---

## Summary

### Key Points

- ✅ **V1.2 is optional** - V1.1 continues to work
- ✅ **Backward compatible** - No breaking changes
- ✅ **Flexible** - Use local storage, database, or both
- ✅ **Well documented** - Comprehensive guides available
- ✅ **Production ready** - Security, backup, monitoring included

### Recommended Upgrade Path

**For Most Users:** Stay on V1.1 (local storage)
- No action required
- Works perfectly for single-user scenarios

**For Enterprise:** Upgrade to V1.2 (with database)
- Centralized configuration management
- Multi-user/multi-device support
- Backup and restore capabilities

### Next Steps

1. Review [Configuration Guide](CONFIGURATION_GUIDE.md)
2. Decide: Local storage only or with database?
3. If database: Follow installation steps
4. Test thoroughly in development
5. Deploy to production

---

**Migration Guide Version:** 1.0  
**Last Updated:** 2025-11-02  
**Student:** HE HUALIANG (230263367)  
**Course:** EEE 4482 - Server Installation and Programming
