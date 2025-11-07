# 完整部署指南 - EEE4482 电子图书馆系统

**学生：** HE HUALIANG (230263367)  
**课程：** EEE 4482 - 服务器安装与编程  
**版本：** 1.2.0  
**日期：** 2025-11-02

---

## 目录

1. [系统概述](#系统概述)
2. [系统要求](#系统要求)
3. [后端部署（PHP + Apache + MariaDB）](#后端部署)
4. [前端部署（Flutter Web）](#前端部署)
5. [数据库配置](#数据库配置)
6. [完整部署流程](#完整部署流程)
7. [测试验证](#测试验证)
8. [常见问题](#常见问题)

---

## 系统概述

EEE4482 电子图书馆系统是一个前后端分离的 Web 应用：

- **前端：** Flutter Web（Dart）
- **后端：** PHP（RESTful API）
- **数据库：** MariaDB/MySQL
- **Web 服务器：** Apache

### 系统架构

```
┌─────────────────┐
│  Flutter Web    │ ←→ HTTP/HTTPS ←→ ┌──────────────┐
│  (前端界面)      │                  │  Apache      │
└─────────────────┘                  │  + PHP       │
                                     └──────────────┘
                                            ↓
                                     ┌──────────────┐
                                     │  MariaDB     │
                                     │  (数据库)     │
                                     └──────────────┘
```

---

## 系统要求

### 服务器要求

**操作系统：**
- Ubuntu 20.04+ / Debian 11+
- CentOS 8+ / RHEL 8+
- 或任何支持 LAMP 的 Linux 发行版

**硬件配置：**
- CPU: 1核心以上
- RAM: 1GB 以上
- 硬盘: 10GB 以上可用空间

**软件要求：**
- Apache 2.4+
- PHP 7.4+ 或 PHP 8.0+
- MariaDB 10.3+ 或 MySQL 5.7+
- Flutter SDK 3.24.0+（用于构建前端）

---

## 后端部署

### 步骤 1：安装 LAMP 环境

#### Ubuntu/Debian 系统

```bash
# 更新系统包
sudo apt update
sudo apt upgrade -y

# 安装 Apache
sudo apt install apache2 -y

# 安装 PHP 和必要扩展
sudo apt install php php-mysql php-mbstring php-xml php-curl -y

# 安装 MariaDB
sudo apt install mariadb-server mariadb-client -y

# 启动并启用服务
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

#### CentOS/RHEL 系统

```bash
# 更新系统包
sudo yum update -y

# 安装 Apache
sudo yum install httpd -y

# 安装 PHP 和扩展
sudo yum install php php-mysqlnd php-mbstring php-xml php-json -y

# 安装 MariaDB
sudo yum install mariadb-server mariadb -y

# 启动并启用服务
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

### 步骤 2：配置 MariaDB 数据库

```bash
# 运行安全配置向导
sudo mysql_secure_installation
```

**配置选项：**
- 设置 root 密码：**是**（设置一个强密码）
- 删除匿名用户：**是**
- 禁止 root 远程登录：**是**
- 删除测试数据库：**是**
- 重新加载权限表：**是**

### 步骤 3：创建数据库和用户

```bash
# 登录 MySQL
sudo mysql -u root -p
```

```sql
-- 创建数据库
CREATE DATABASE elibrary CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建数据库用户
CREATE USER 'elibrary_user'@'localhost' IDENTIFIED BY 'your_secure_password';

-- 授予权限
GRANT ALL PRIVILEGES ON elibrary.* TO 'elibrary_user'@'localhost';

-- 刷新权限
FLUSH PRIVILEGES;

-- 退出
EXIT;
```

### 步骤 4：导入数据库架构

```bash
# 从项目仓库导入基础架构
cd /path/to/eee4482
mysql -u elibrary_user -p elibrary < database/schema.sql

# 导入认证架构
mysql -u elibrary_user -p elibrary < database/auth_schema.sql
```

### 步骤 5：配置 Apache 虚拟主机

创建虚拟主机配置文件：

```bash
# Ubuntu/Debian
sudo nano /etc/apache2/sites-available/elibrary.conf

# CentOS/RHEL
sudo nano /etc/httpd/conf.d/elibrary.conf
```

**配置内容：**

```apache
<VirtualHost *:80>
    ServerName elibrary.local
    ServerAlias www.elibrary.local
    DocumentRoot /var/www/elibrary

    # API 目录配置
    <Directory /var/www/elibrary>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # 启用 CORS（开发环境）
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization"
    Header always set Access-Control-Allow-Credentials "true"

    # 日志配置
    ErrorLog ${APACHE_LOG_DIR}/elibrary_error.log
    CustomLog ${APACHE_LOG_DIR}/elibrary_access.log combined
</VirtualHost>
```

### 步骤 6：启用必要的 Apache 模块

```bash
# Ubuntu/Debian
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2ensite elibrary
sudo systemctl restart apache2

# CentOS/RHEL
sudo systemctl restart httpd
```

### 步骤 7：创建 PHP 后端 API

创建项目目录：

```bash
sudo mkdir -p /var/www/elibrary/api
sudo chown -R www-data:www-data /var/www/elibrary  # Ubuntu/Debian
# 或
sudo chown -R apache:apache /var/www/elibrary      # CentOS/RHEL
```

创建数据库配置文件：

```bash
sudo nano /var/www/elibrary/api/config.php
```

```php
<?php
// 数据库配置
define('DB_HOST', 'localhost');
define('DB_NAME', 'elibrary');
define('DB_USER', 'elibrary_user');
define('DB_PASS', 'your_secure_password');
define('DB_CHARSET', 'utf8mb4');

// 错误报告（生产环境设为 0）
error_reporting(E_ALL);
ini_set('display_errors', 1);

// CORS 配置
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json; charset=UTF-8');

// 处理 OPTIONS 请求
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// 数据库连接
try {
    $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
    $pdo = new PDO($dsn, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database connection failed']);
    exit();
}
?>
```

创建图书 API 端点：

```bash
sudo nano /var/www/elibrary/api/books.php
```

```php
<?php
require_once 'config.php';

$method = $_SERVER['REQUEST_METHOD'];

try {
    switch ($method) {
        case 'GET':
            // 获取所有图书
            if (isset($_GET['id'])) {
                // 获取单本图书
                $stmt = $pdo->prepare("SELECT * FROM books WHERE id = ?");
                $stmt->execute([$_GET['id']]);
                $book = $stmt->fetch();
                echo json_encode($book ?: ['error' => 'Book not found']);
            } else {
                // 获取所有图书
                $stmt = $pdo->query("SELECT * FROM books ORDER BY created_at DESC");
                $books = $stmt->fetchAll();
                echo json_encode($books);
            }
            break;

        case 'POST':
            // 添加新图书
            $data = json_decode(file_get_contents('php://input'), true);
            
            $stmt = $pdo->prepare("
                INSERT INTO books (title, author, publisher, isbn, publication_date, description, category)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            ");
            
            $stmt->execute([
                $data['title'],
                $data['author'],
                $data['publisher'] ?? null,
                $data['isbn'] ?? null,
                $data['publication_date'] ?? null,
                $data['description'] ?? null,
                $data['category'] ?? null
            ]);
            
            echo json_encode([
                'success' => true,
                'id' => $pdo->lastInsertId(),
                'message' => 'Book added successfully'
            ]);
            break;

        case 'PUT':
            // 更新图书
            $data = json_decode(file_get_contents('php://input'), true);
            
            $stmt = $pdo->prepare("
                UPDATE books 
                SET title = ?, author = ?, publisher = ?, isbn = ?, 
                    publication_date = ?, description = ?, category = ?
                WHERE id = ?
            ");
            
            $stmt->execute([
                $data['title'],
                $data['author'],
                $data['publisher'] ?? null,
                $data['isbn'] ?? null,
                $data['publication_date'] ?? null,
                $data['description'] ?? null,
                $data['category'] ?? null,
                $data['id']
            ]);
            
            echo json_encode([
                'success' => true,
                'message' => 'Book updated successfully'
            ]);
            break;

        case 'DELETE':
            // 删除图书
            $id = $_GET['id'] ?? null;
            
            if (!$id) {
                throw new Exception('Book ID is required');
            }
            
            $stmt = $pdo->prepare("DELETE FROM books WHERE id = ?");
            $stmt->execute([$id]);
            
            echo json_encode([
                'success' => true,
                'message' => 'Book deleted successfully'
            ]);
            break;

        default:
            http_response_code(405);
            echo json_encode(['error' => 'Method not allowed']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
?>
```

创建用户认证 API：

```bash
sudo nano /var/www/elibrary/api/auth.php
```

```php
<?php
require_once 'config.php';

$method = $_SERVER['REQUEST_METHOD'];
$action = $_GET['action'] ?? '';

try {
    switch ($action) {
        case 'login':
            // 用户登录
            $data = json_decode(file_get_contents('php://input'), true);
            
            $stmt = $pdo->prepare("
                SELECT id, username, email, role 
                FROM users 
                WHERE username = ? AND password_hash = SHA2(?, 256) AND is_active = 1
            ");
            $stmt->execute([$data['username'], $data['password']]);
            $user = $stmt->fetch();
            
            if ($user) {
                // 更新最后登录时间
                $updateStmt = $pdo->prepare("UPDATE users SET last_login_at = NOW() WHERE id = ?");
                $updateStmt->execute([$user['id']]);
                
                // 生成令牌（简单示例，生产环境使用 JWT）
                $token = bin2hex(random_bytes(32));
                
                echo json_encode([
                    'success' => true,
                    'token' => $token,
                    'user' => $user
                ]);
            } else {
                http_response_code(401);
                echo json_encode(['error' => 'Invalid credentials']);
            }
            break;

        case 'register':
            // 用户注册
            $data = json_decode(file_get_contents('php://input'), true);
            
            // 检查用户名是否已存在
            $stmt = $pdo->prepare("SELECT id FROM users WHERE username = ?");
            $stmt->execute([$data['username']]);
            if ($stmt->fetch()) {
                http_response_code(400);
                echo json_encode(['error' => 'Username already exists']);
                break;
            }
            
            // 插入新用户
            $stmt = $pdo->prepare("
                INSERT INTO users (username, email, password_hash, role, is_active, is_email_verified)
                VALUES (?, ?, SHA2(?, 256), 'user', 1, 0)
            ");
            $stmt->execute([
                $data['username'],
                $data['email'],
                $data['password']
            ]);
            
            echo json_encode([
                'success' => true,
                'message' => 'Registration successful',
                'user_id' => $pdo->lastInsertId()
            ]);
            break;

        default:
            http_response_code(400);
            echo json_encode(['error' => 'Invalid action']);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
}
?>
```

设置文件权限：

```bash
sudo chmod 755 /var/www/elibrary/api/*.php
sudo chown -R www-data:www-data /var/www/elibrary  # Ubuntu/Debian
# 或
sudo chown -R apache:apache /var/www/elibrary      # CentOS/RHEL
```

---

## 前端部署

### 步骤 1：安装 Flutter SDK

```bash
# 下载 Flutter
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz

# 解压
tar xf flutter_linux_3.24.0-stable.tar.xz

# 添加到 PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# 验证安装
flutter doctor
```

### 步骤 2：获取项目代码

```bash
# 克隆项目
cd ~
git clone https://github.com/TerryNex/eee4482.git
cd eee4482

# 安装依赖
flutter pub get
```

### 步骤 3：配置 API 端点

编辑 API 配置文件：

```bash
nano lib/config/api_config.dart
```

更新 base URL：

```dart
class ApiConfig {
  // 更改为你的服务器 IP 地址
  static const String baseUrl = 'http://YOUR_SERVER_IP/api';
  
  // 其他配置保持不变
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  
  // API 端点
  static const String getAllBooksEndpoint = '/books.php';
  static const String addBookEndpoint = '/books.php';
  static const String updateBookEndpoint = '/books.php';
  static const String deleteBookEndpoint = '/books.php';
  static const String loginEndpoint = '/auth.php?action=login';
  static const String registerEndpoint = '/auth.php?action=register';
}
```

### 步骤 4：构建 Web 应用

```bash
# 构建生产版本
flutter build web --release

# 构建产物在 build/web/ 目录
```

### 步骤 5：部署到 Apache

```bash
# 复制构建产物到 Web 目录
sudo mkdir -p /var/www/elibrary/web
sudo cp -r build/web/* /var/www/elibrary/web/

# 设置权限
sudo chown -R www-data:www-data /var/www/elibrary/web  # Ubuntu/Debian
# 或
sudo chown -R apache:apache /var/www/elibrary/web      # CentOS/RHEL
```

### 步骤 6：更新 Apache 配置

更新虚拟主机配置：

```bash
# Ubuntu/Debian
sudo nano /etc/apache2/sites-available/elibrary.conf

# CentOS/RHEL
sudo nano /etc/httpd/conf.d/elibrary.conf
```

添加前端配置：

```apache
<VirtualHost *:80>
    ServerName elibrary.local
    DocumentRoot /var/www/elibrary/web

    # 前端目录
    <Directory /var/www/elibrary/web>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        
        # SPA 路由支持
        <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteBase /
            RewriteRule ^index\.html$ - [L]
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteRule . /index.html [L]
        </IfModule>
    </Directory>

    # API 别名
    Alias /api /var/www/elibrary/api
    <Directory /var/www/elibrary/api>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # CORS 配置
    Header always set Access-Control-Allow-Origin "*"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization"

    ErrorLog ${APACHE_LOG_DIR}/elibrary_error.log
    CustomLog ${APACHE_LOG_DIR}/elibrary_access.log combined
</VirtualHost>
```

重启 Apache：

```bash
# Ubuntu/Debian
sudo systemctl restart apache2

# CentOS/RHEL
sudo systemctl restart httpd
```

---

## 数据库配置

### 查看数据库表

```bash
mysql -u elibrary_user -p elibrary
```

```sql
-- 查看所有表
SHOW TABLES;

-- 查看图书表结构
DESCRIBE books;

-- 查看用户表
DESCRIBE users;

-- 插入测试数据
INSERT INTO books (title, author, publisher, isbn, publication_date, description, category)
VALUES 
('Flutter 入门教程', '张三', '电子工业出版社', '978-1-234567-89-0', '2024-01-15', 'Flutter 开发入门指南', '编程'),
('数据库原理', '李四', '清华大学出版社', '978-9-876543-21-0', '2023-06-20', '数据库系统概论', '计算机科学');
```

---

## 完整部署流程

### 快速部署脚本

创建自动化部署脚本：

```bash
nano deploy.sh
```

```bash
#!/bin/bash

echo "=== EEE4482 电子图书馆系统 - 自动部署脚本 ==="
echo ""

# 配置变量
DB_NAME="elibrary"
DB_USER="elibrary_user"
DB_PASS="your_secure_password"
WEB_ROOT="/var/www/elibrary"
PROJECT_DIR="$HOME/eee4482"

# 1. 检查并安装依赖
echo "[1/8] 检查系统依赖..."
if ! command -v apache2 &> /dev/null && ! command -v httpd &> /dev/null; then
    echo "正在安装 Apache..."
    sudo apt install apache2 -y || sudo yum install httpd -y
fi

if ! command -v php &> /dev/null; then
    echo "正在安装 PHP..."
    sudo apt install php php-mysql php-mbstring php-xml -y || sudo yum install php php-mysqlnd -y
fi

if ! command -v mysql &> /dev/null; then
    echo "正在安装 MariaDB..."
    sudo apt install mariadb-server -y || sudo yum install mariadb-server -y
fi

# 2. 创建数据库
echo "[2/8] 配置数据库..."
mysql -u root -p <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

# 3. 导入数据库架构
echo "[3/8] 导入数据库架构..."
mysql -u $DB_USER -p$DB_PASS $DB_NAME < $PROJECT_DIR/database/schema.sql
mysql -u $DB_USER -p$DB_PASS $DB_NAME < $PROJECT_DIR/database/auth_schema.sql

# 4. 创建 Web 目录
echo "[4/8] 创建 Web 目录..."
sudo mkdir -p $WEB_ROOT/api
sudo mkdir -p $WEB_ROOT/web

# 5. 复制 API 文件
echo "[5/8] 部署后端 API..."
# 需要手动创建 API 文件，或从模板复制

# 6. 构建前端
echo "[6/8] 构建前端应用..."
cd $PROJECT_DIR
flutter pub get
flutter build web --release

# 7. 复制前端文件
echo "[7/8] 部署前端文件..."
sudo cp -r $PROJECT_DIR/build/web/* $WEB_ROOT/web/

# 8. 设置权限
echo "[8/8] 设置文件权限..."
if command -v apache2 &> /dev/null; then
    sudo chown -R www-data:www-data $WEB_ROOT
else
    sudo chown -R apache:apache $WEB_ROOT
fi

echo ""
echo "=== 部署完成！==="
echo "访问地址: http://YOUR_SERVER_IP"
echo "默认管理员账号: admin / Admin@123"
```

运行部署脚本：

```bash
chmod +x deploy.sh
./deploy.sh
```

---

## 测试验证

### 1. 测试数据库连接

```bash
mysql -u elibrary_user -p elibrary -e "SELECT COUNT(*) FROM books;"
```

### 2. 测试 PHP API

```bash
# 测试获取图书
curl http://YOUR_SERVER_IP/api/books.php

# 测试添加图书
curl -X POST http://YOUR_SERVER_IP/api/books.php \
  -H "Content-Type: application/json" \
  -d '{"title":"测试图书","author":"测试作者"}'
```

### 3. 测试前端应用

1. 打开浏览器访问 `http://YOUR_SERVER_IP`
2. 应该看到登录页面
3. 点击注册，创建新账户
4. 使用新账户登录
5. 测试各项功能

### 4. 测试认证流程

- 注册新用户
- 登录系统
- 刷新页面验证会话保持
- 访问 Dashboard
- 测试登出功能

---

## 常见问题

### 问题 1：无法连接数据库

**症状：** "Database connection failed"

**解决方案：**
```bash
# 检查 MariaDB 是否运行
sudo systemctl status mariadb

# 检查用户权限
mysql -u elibrary_user -p
```

### 问题 2：CORS 错误

**症状：** "Access-Control-Allow-Origin" 错误

**解决方案：**
```bash
# 启用 headers 模块
sudo a2enmod headers
sudo systemctl restart apache2

# 检查虚拟主机配置中的 CORS 设置
```

### 问题 3：404 错误（API 请求）

**症状：** API 端点返回 404

**解决方案：**
```bash
# 检查文件权限
ls -la /var/www/elibrary/api/

# 检查 Apache 错误日志
sudo tail -f /var/log/apache2/error.log  # Ubuntu
sudo tail -f /var/log/httpd/error_log     # CentOS
```

### 问题 4：Flutter 应用白屏

**症状：** 浏览器显示白屏

**解决方案：**
```bash
# 检查浏览器控制台错误
# 确保所有资源文件正确复制
ls -la /var/www/elibrary/web/

# 重新构建并部署
flutter clean
flutter pub get
flutter build web --release
sudo cp -r build/web/* /var/www/elibrary/web/
```

### 问题 5：会话不持久

**症状：** 刷新后需要重新登录

**解决方案：**
- 已在最新代码中修复
- 确保使用最新版本的 `lib/providers/auth_provider.dart`

---

## 安全建议

### 生产环境配置

1. **使用 HTTPS**
```bash
# 安装 Let's Encrypt
sudo apt install certbot python3-certbot-apache
sudo certbot --apache -d yourdomain.com
```

2. **强化数据库安全**
```sql
-- 使用强密码
-- 限制远程访问
-- 定期备份
```

3. **PHP 安全配置**
```bash
# 编辑 php.ini
sudo nano /etc/php/8.1/apache2/php.ini

# 关闭错误显示
display_errors = Off
log_errors = On

# 限制文件上传
upload_max_filesize = 10M
post_max_size = 10M
```

4. **定期备份**
```bash
# 数据库备份脚本
#!/bin/bash
mysqldump -u elibrary_user -p elibrary > backup_$(date +%Y%m%d).sql
```

---

## 维护命令

### 重启服务

```bash
# 重启 Apache
sudo systemctl restart apache2  # Ubuntu
sudo systemctl restart httpd     # CentOS

# 重启 MariaDB
sudo systemctl restart mariadb
```

### 查看日志

```bash
# Apache 错误日志
sudo tail -f /var/log/apache2/error.log     # Ubuntu
sudo tail -f /var/log/httpd/error_log       # CentOS

# Apache 访问日志
sudo tail -f /var/log/apache2/access.log    # Ubuntu
sudo tail -f /var/log/httpd/access_log      # CentOS

# MariaDB 错误日志
sudo tail -f /var/log/mysql/error.log
```

### 数据库备份与恢复

```bash
# 备份
mysqldump -u elibrary_user -p elibrary > backup.sql

# 恢复
mysql -u elibrary_user -p elibrary < backup.sql
```

---

## 联系支持

**学生：** HE HUALIANG (230263367)  
**课程：** EEE 4482 - 服务器安装与编程  

如有问题，请参考：
- [README.md](../README.md) - 项目概述
- [CONFIGURATION_GUIDE.md](CONFIGURATION_GUIDE.md) - 配置指南
- [API_PROXY_VALIDATION_GUIDE.md](API_PROXY_VALIDATION_GUIDE.md) - API 文档

---

**部署指南版本：** 1.0  
**最后更新：** 2025-11-02  
**状态：** ✅ 完整且已测试
