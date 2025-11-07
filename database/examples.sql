-- =====================================================
-- EEE4482 e-Library - Example SQL Scripts
-- Student: HE HUALIANG (230263367)
-- Purpose: Common configuration scenarios using SQL
-- =====================================================

USE elibrary;

-- =====================================================
-- Example 1: Update API Base URL
-- =====================================================

-- Update API base URL for production
CALL update_api_setting(
    'base_url', 
    'https://api.elibrary.com', 
    'Production API Base URL'
);

-- Update API base URL for development
CALL update_api_setting(
    'base_url', 
    'http://localhost:3000/api', 
    'Development API Base URL'
);

-- Update API base URL for local network testing
CALL update_api_setting(
    'base_url', 
    'http://192.168.1.100/api/public', 
    'Local Network API Base URL'
);

-- =====================================================
-- Example 2: Configure Timeout Settings
-- =====================================================

-- Increase timeout for slow networks
CALL update_api_setting('connection_timeout', '60', 'Connection timeout - 60 seconds');
CALL update_api_setting('receive_timeout', '60', 'Receive timeout - 60 seconds');

-- Decrease timeout for fast networks
CALL update_api_setting('connection_timeout', '15', 'Connection timeout - 15 seconds');
CALL update_api_setting('receive_timeout', '15', 'Receive timeout - 15 seconds');

-- Reset to default timeout
CALL update_api_setting('connection_timeout', '30', 'Connection timeout - default');
CALL update_api_setting('receive_timeout', '30', 'Receive timeout - default');

-- =====================================================
-- Example 3: Enable/Disable Authentication
-- =====================================================

-- Enable authentication
CALL update_api_setting('auth_enabled', 'true', 'Authentication enabled');
CALL update_api_setting('auth_token', 'your-jwt-token-here', 'Bearer token for authentication');

-- Disable authentication
CALL update_api_setting('auth_enabled', 'false', 'Authentication disabled');
CALL update_api_setting('auth_token', '', 'No authentication token');

-- =====================================================
-- Example 4: Configure Development Proxy
-- =====================================================

-- Enable development proxy for CORS bypass
CALL update_proxy_config(
    'development',      -- config_name
    TRUE,              -- enabled
    'localhost',       -- proxy_host
    8080,              -- proxy_port
    'http'             -- proxy_type
);

-- =====================================================
-- Example 5: Configure Corporate Proxy
-- =====================================================

-- Enable corporate network proxy
CALL update_proxy_config(
    'corporate',           -- config_name
    TRUE,                  -- enabled
    'proxy.company.com',   -- proxy_host
    3128,                  -- proxy_port
    'http'                 -- proxy_type
);

-- =====================================================
-- Example 6: Disable Proxy
-- =====================================================

-- Disable proxy
CALL update_proxy_config(
    'default',      -- config_name
    FALSE,         -- enabled (disabled)
    'localhost',   -- proxy_host (placeholder)
    8080,          -- proxy_port (placeholder)
    'http'         -- proxy_type
);

-- =====================================================
-- Example 7: Multiple Proxy Configurations
-- =====================================================

-- Add staging proxy configuration
INSERT INTO proxy_config 
    (config_name, enabled, proxy_host, proxy_port, proxy_type, description, is_default)
VALUES 
    ('staging', FALSE, 'proxy.staging.com', 8080, 'http', 'Staging environment proxy', FALSE);

-- Add production proxy configuration
INSERT INTO proxy_config 
    (config_name, enabled, proxy_host, proxy_port, proxy_type, description, is_default)
VALUES 
    ('production', FALSE, 'proxy.prod.com', 3128, 'https', 'Production environment proxy', FALSE);

-- Switch to staging proxy
UPDATE proxy_config SET is_default = FALSE WHERE is_default = TRUE;
UPDATE proxy_config SET is_default = TRUE, enabled = TRUE WHERE config_name = 'staging';

-- =====================================================
-- Example 8: Query Current Configuration
-- =====================================================

-- Get all API settings
SELECT * FROM api_settings WHERE is_active = TRUE;

-- Get only active API settings
SELECT * FROM active_api_settings;

-- Get current API configuration as JSON
CALL get_current_api_config();

-- Get all proxy configurations
SELECT * FROM proxy_config ORDER BY is_default DESC, config_name;

-- Get only the active proxy
SELECT * FROM active_proxy_config;

-- Get current proxy configuration as JSON
CALL get_current_proxy_config();

-- =====================================================
-- Example 9: User-Specific Settings
-- =====================================================

-- Add user theme preference (user_id = 1)
INSERT INTO user_settings (user_id, setting_key, setting_value)
VALUES (1, 'theme', 'githubHighContrast')
ON DUPLICATE KEY UPDATE 
    setting_value = 'githubHighContrast',
    updated_at = CURRENT_TIMESTAMP;

-- Add user language preference
INSERT INTO user_settings (user_id, setting_key, setting_value)
VALUES (1, 'language', 'en')
ON DUPLICATE KEY UPDATE 
    setting_value = 'en',
    updated_at = CURRENT_TIMESTAMP;

-- Get all settings for a user
SELECT setting_key, setting_value FROM user_settings WHERE user_id = 1;

-- =====================================================
-- Example 10: Backup and Restore Configuration
-- =====================================================

-- Backup current configuration
SELECT 'API Settings Backup' AS backup_type;
SELECT * FROM api_settings;

SELECT 'Proxy Config Backup' AS backup_type;
SELECT * FROM proxy_config;

-- Example restore from backup (adjust values as needed)
-- TRUNCATE TABLE api_settings;
-- TRUNCATE TABLE proxy_config;
-- INSERT INTO api_settings ... (use your backup data)
-- INSERT INTO proxy_config ... (use your backup data)

-- =====================================================
-- Example 11: Reset to Default Configuration
-- =====================================================

-- Reset API settings to defaults
UPDATE api_settings SET 
    setting_value = CASE setting_key
        WHEN 'base_url' THEN 'http://192.168.1.100/api/public'
        WHEN 'connection_timeout' THEN '30'
        WHEN 'receive_timeout' THEN '30'
        WHEN 'auth_enabled' THEN 'false'
        WHEN 'auth_token' THEN ''
        ELSE setting_value
    END,
    updated_at = CURRENT_TIMESTAMP;

-- Reset proxy to default (disabled)
UPDATE proxy_config SET is_default = FALSE;
UPDATE proxy_config SET 
    enabled = FALSE,
    is_default = TRUE,
    updated_at = CURRENT_TIMESTAMP
WHERE config_name = 'default';

-- =====================================================
-- Example 12: Monitoring and Auditing
-- =====================================================

-- Check when settings were last updated
SELECT 
    setting_key,
    setting_value,
    updated_at,
    TIMESTAMPDIFF(MINUTE, updated_at, NOW()) AS minutes_since_update
FROM api_settings
ORDER BY updated_at DESC;

-- Check proxy configuration history
SELECT 
    config_name,
    enabled,
    is_default,
    updated_at,
    TIMESTAMPDIFF(HOUR, updated_at, NOW()) AS hours_since_update
FROM proxy_config
ORDER BY updated_at DESC;

-- =====================================================
-- Example 13: Advanced Queries
-- =====================================================

-- Get API configuration as key-value pairs
SELECT 
    setting_key AS 'key',
    setting_value AS 'value'
FROM api_settings
WHERE is_active = TRUE;

-- Get enabled proxy configurations
SELECT 
    config_name,
    CONCAT(proxy_host, ':', proxy_port) AS proxy_url,
    proxy_type,
    description
FROM proxy_config
WHERE enabled = TRUE;

-- Find outdated configurations (not updated in 30 days)
SELECT 
    setting_key,
    setting_value,
    updated_at,
    DATEDIFF(NOW(), updated_at) AS days_old
FROM api_settings
WHERE DATEDIFF(NOW(), updated_at) > 30;

-- =====================================================
-- Example 14: Validate Configuration
-- =====================================================

-- Check for duplicate settings
SELECT 
    setting_key,
    COUNT(*) AS count
FROM api_settings
GROUP BY setting_key
HAVING count > 1;

-- Verify proxy ports are valid
SELECT 
    config_name,
    proxy_port,
    CASE 
        WHEN proxy_port < 1 OR proxy_port > 65535 THEN 'INVALID'
        ELSE 'VALID'
    END AS port_status
FROM proxy_config;

-- Check for missing required settings
SELECT 'base_url' AS required_setting
WHERE NOT EXISTS (SELECT 1 FROM api_settings WHERE setting_key = 'base_url')
UNION
SELECT 'connection_timeout'
WHERE NOT EXISTS (SELECT 1 FROM api_settings WHERE setting_key = 'connection_timeout')
UNION
SELECT 'receive_timeout'
WHERE NOT EXISTS (SELECT 1 FROM api_settings WHERE setting_key = 'receive_timeout');

-- =====================================================
-- Example 15: Cleanup Old Data
-- =====================================================

-- Delete inactive settings (use with caution)
-- DELETE FROM api_settings WHERE is_active = FALSE;

-- Delete old user settings for deleted users (example)
-- DELETE FROM user_settings WHERE user_id NOT IN (SELECT id FROM users);

-- Archive old proxy configurations
-- UPDATE proxy_config SET is_active = FALSE 
-- WHERE is_active = TRUE 
--   AND is_default = FALSE 
--   AND DATEDIFF(NOW(), updated_at) > 90;

-- =====================================================
-- Example 16: Export Configuration for Documentation
-- =====================================================

-- Export API settings in documentation format
SELECT 
    CONCAT('- **', setting_key, '**: `', setting_value, '`') AS markdown_format
FROM api_settings
WHERE is_active = TRUE
ORDER BY setting_key;

-- Export proxy settings
SELECT 
    CONCAT('### ', config_name, '\n',
           '- Host: ', proxy_host, '\n',
           '- Port: ', proxy_port, '\n',
           '- Type: ', proxy_type, '\n',
           '- Enabled: ', IF(enabled, 'Yes', 'No')) AS config_doc
FROM proxy_config
WHERE is_active = TRUE;

-- =====================================================
-- Example 17: Testing and Development
-- =====================================================

-- Create test configuration set
INSERT INTO api_settings (setting_key, setting_value, description, is_active) VALUES
('test_base_url', 'http://localhost:3000/api', 'Test environment base URL', FALSE),
('test_timeout', '10', 'Short timeout for testing', FALSE);

-- Switch between production and test configurations
-- UPDATE api_settings SET is_active = FALSE WHERE setting_key LIKE 'test_%';
-- UPDATE api_settings SET is_active = TRUE WHERE setting_key IN ('base_url', 'connection_timeout');

-- =====================================================
-- End of Examples
-- =====================================================

-- Display summary of current configuration
SELECT '=== Current Configuration Summary ===' AS summary;
SELECT 'API Settings:' AS section;
SELECT setting_key, setting_value FROM api_settings WHERE is_active = TRUE;
SELECT 'Proxy Configuration:' AS section;
SELECT config_name, enabled, CONCAT(proxy_host, ':', proxy_port) AS proxy_url FROM proxy_config WHERE is_default = TRUE;
