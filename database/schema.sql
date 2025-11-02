-- =====================================================
-- EEE4482 e-Library Database Schema
-- Student: HE HUALIANG (230263367)
-- Purpose: Database schema for persistent API and Proxy configuration
-- Database: MariaDB / MySQL
-- =====================================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS elibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE elibrary;

-- =====================================================
-- Table: api_settings
-- Purpose: Store API configuration settings
-- =====================================================
CREATE TABLE IF NOT EXISTS api_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE COMMENT 'Configuration key (e.g., base_url, timeout)',
    setting_value TEXT NOT NULL COMMENT 'Configuration value',
    description TEXT COMMENT 'Description of the setting',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Whether this setting is currently active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When the setting was created',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update time',
    INDEX idx_setting_key (setting_key),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB COMMENT='API configuration settings';

-- =====================================================
-- Table: proxy_config
-- Purpose: Store proxy configuration settings
-- =====================================================
CREATE TABLE IF NOT EXISTS proxy_config (
    id INT AUTO_INCREMENT PRIMARY KEY,
    config_name VARCHAR(100) NOT NULL COMMENT 'Configuration name (e.g., development, production)',
    enabled BOOLEAN DEFAULT FALSE COMMENT 'Whether proxy is enabled',
    proxy_host VARCHAR(255) NOT NULL COMMENT 'Proxy server hostname or IP',
    proxy_port INT NOT NULL COMMENT 'Proxy server port (1-65535)',
    proxy_type ENUM('http', 'https', 'socks5') DEFAULT 'http' COMMENT 'Type of proxy',
    username VARCHAR(100) DEFAULT NULL COMMENT 'Proxy authentication username',
    password VARCHAR(255) DEFAULT NULL COMMENT 'Proxy authentication password (encrypted)',
    description TEXT COMMENT 'Description of this proxy configuration',
    is_default BOOLEAN DEFAULT FALSE COMMENT 'Whether this is the default configuration',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Whether this configuration is active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When the configuration was created',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update time',
    INDEX idx_config_name (config_name),
    INDEX idx_is_default (is_default),
    INDEX idx_is_active (is_active),
    CONSTRAINT chk_proxy_port CHECK (proxy_port >= 1 AND proxy_port <= 65535)
) ENGINE=InnoDB COMMENT='Proxy configuration settings';

-- =====================================================
-- Table: user_settings
-- Purpose: Store user-specific settings (theme, preferences)
-- =====================================================
CREATE TABLE IF NOT EXISTS user_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL COMMENT 'User ID (if user authentication is implemented)',
    setting_key VARCHAR(100) NOT NULL COMMENT 'Setting key (e.g., theme, language)',
    setting_value TEXT NOT NULL COMMENT 'Setting value',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When the setting was created',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last update time',
    UNIQUE KEY uk_user_setting (user_id, setting_key),
    INDEX idx_user_id (user_id),
    INDEX idx_setting_key (setting_key)
) ENGINE=InnoDB COMMENT='User-specific settings';

-- =====================================================
-- Default Data: api_settings
-- =====================================================
INSERT INTO api_settings (setting_key, setting_value, description) VALUES
('base_url', 'http://192.168.1.100/api/public', 'Base URL for API endpoints'),
('connection_timeout', '30', 'Connection timeout in seconds'),
('receive_timeout', '30', 'Receive timeout in seconds'),
('auth_enabled', 'false', 'Whether authentication is enabled'),
('auth_token', '', 'Authentication bearer token')
ON DUPLICATE KEY UPDATE 
    setting_value = VALUES(setting_value),
    updated_at = CURRENT_TIMESTAMP;

-- =====================================================
-- Default Data: proxy_config
-- =====================================================
INSERT INTO proxy_config (config_name, enabled, proxy_host, proxy_port, proxy_type, description, is_default) VALUES
('default', FALSE, 'localhost', 8080, 'http', 'Default proxy configuration (disabled)', TRUE),
('development', FALSE, 'localhost', 8080, 'http', 'Development CORS proxy', FALSE),
('corporate', FALSE, 'proxy.company.com', 3128, 'http', 'Corporate network proxy', FALSE)
ON DUPLICATE KEY UPDATE 
    updated_at = CURRENT_TIMESTAMP;

-- =====================================================
-- Views for easy access
-- =====================================================

-- View: active_api_settings
-- Purpose: Get all active API settings
CREATE OR REPLACE VIEW active_api_settings AS
SELECT 
    setting_key,
    setting_value,
    description,
    updated_at
FROM api_settings
WHERE is_active = TRUE
ORDER BY setting_key;

-- View: active_proxy_config
-- Purpose: Get the active proxy configuration
CREATE OR REPLACE VIEW active_proxy_config AS
SELECT 
    config_name,
    enabled,
    proxy_host,
    proxy_port,
    proxy_type,
    description,
    updated_at
FROM proxy_config
WHERE is_active = TRUE AND is_default = TRUE
LIMIT 1;

-- =====================================================
-- Stored Procedures
-- =====================================================

DELIMITER $$

-- Procedure: update_api_setting
-- Purpose: Update or insert an API setting
CREATE PROCEDURE IF NOT EXISTS update_api_setting(
    IN p_key VARCHAR(100),
    IN p_value TEXT,
    IN p_description TEXT
)
BEGIN
    INSERT INTO api_settings (setting_key, setting_value, description)
    VALUES (p_key, p_value, p_description)
    ON DUPLICATE KEY UPDATE 
        setting_value = p_value,
        description = COALESCE(p_description, description),
        updated_at = CURRENT_TIMESTAMP;
END$$

-- Procedure: update_proxy_config
-- Purpose: Update proxy configuration
CREATE PROCEDURE IF NOT EXISTS update_proxy_config(
    IN p_config_name VARCHAR(100),
    IN p_enabled BOOLEAN,
    IN p_host VARCHAR(255),
    IN p_port INT,
    IN p_type VARCHAR(10)
)
BEGIN
    -- First, unset any existing default
    IF p_enabled = TRUE THEN
        UPDATE proxy_config SET is_default = FALSE WHERE is_default = TRUE;
    END IF;
    
    -- Update or insert the configuration
    INSERT INTO proxy_config (config_name, enabled, proxy_host, proxy_port, proxy_type, is_default)
    VALUES (p_config_name, p_enabled, p_host, p_port, p_type, p_enabled)
    ON DUPLICATE KEY UPDATE 
        enabled = p_enabled,
        proxy_host = p_host,
        proxy_port = p_port,
        proxy_type = p_type,
        is_default = p_enabled,
        updated_at = CURRENT_TIMESTAMP;
END$$

-- Procedure: get_current_api_config
-- Purpose: Get current API configuration as JSON
CREATE PROCEDURE IF NOT EXISTS get_current_api_config()
BEGIN
    SELECT 
        JSON_OBJECT(
            'baseUrl', MAX(CASE WHEN setting_key = 'base_url' THEN setting_value END),
            'connectionTimeout', CAST(MAX(CASE WHEN setting_key = 'connection_timeout' THEN setting_value END) AS UNSIGNED),
            'receiveTimeout', CAST(MAX(CASE WHEN setting_key = 'receive_timeout' THEN setting_value END) AS UNSIGNED),
            'authEnabled', MAX(CASE WHEN setting_key = 'auth_enabled' THEN setting_value END) = 'true',
            'authToken', MAX(CASE WHEN setting_key = 'auth_token' THEN setting_value END)
        ) AS config
    FROM api_settings
    WHERE is_active = TRUE;
END$$

-- Procedure: get_current_proxy_config
-- Purpose: Get current proxy configuration as JSON
CREATE PROCEDURE IF NOT EXISTS get_current_proxy_config()
BEGIN
    SELECT 
        JSON_OBJECT(
            'configName', config_name,
            'enabled', enabled,
            'proxyHost', proxy_host,
            'proxyPort', proxy_port,
            'proxyType', proxy_type,
            'username', username,
            'description', description
        ) AS config
    FROM proxy_config
    WHERE is_active = TRUE AND is_default = TRUE
    LIMIT 1;
END$$

DELIMITER ;

-- =====================================================
-- Indexes for performance
-- =====================================================

-- Already created inline with table definitions

-- =====================================================
-- Grants (adjust username/host as needed)
-- =====================================================

-- Example: Grant privileges to elibrary user
-- GRANT SELECT, INSERT, UPDATE ON elibrary.* TO 'elibrary_user'@'localhost';
-- GRANT EXECUTE ON PROCEDURE elibrary.update_api_setting TO 'elibrary_user'@'localhost';
-- GRANT EXECUTE ON PROCEDURE elibrary.update_proxy_config TO 'elibrary_user'@'localhost';
-- GRANT EXECUTE ON PROCEDURE elibrary.get_current_api_config TO 'elibrary_user'@'localhost';
-- GRANT EXECUTE ON PROCEDURE elibrary.get_current_proxy_config TO 'elibrary_user'@'localhost';
-- FLUSH PRIVILEGES;

-- =====================================================
-- End of Schema
-- =====================================================
