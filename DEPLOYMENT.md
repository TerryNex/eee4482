# Deployment Guide - EEE4482 e-Library

**Student:** HE HUALIANG (230263367)  
**Version:** V1.0

This guide provides detailed instructions for deploying the EEE4482 e-Library Flutter application to various platforms.

---

## Table of Contents

- [Web Deployment to Apache Server](#web-deployment-to-apache-server)
- [Desktop Application Deployment](#desktop-application-deployment)
- [GitHub Actions Deployment](#github-actions-deployment)
- [Post-Deployment Verification](#post-deployment-verification)
- [Common Issues](#common-issues)

---

## Web Deployment to Apache Server

This section covers deploying the Flutter web application to an Apache server (as per Worksheet 7g).

### Prerequisites

- Apache web server installed and running on your server
- Server accessible via IP address or domain name
- SSH/SFTP access to the server
- FileZilla or similar FTP client (optional, for GUI users)

### Step 1: Build the Flutter Web Application

On your development machine:

```bash
# Navigate to project directory
cd /path/to/eee4482

# Build for web (production mode)
flutter build web --release
```

**What this does:**
- Compiles Dart code to optimized JavaScript
- Bundles all assets and resources
- Creates a production-ready web application
- Output location: `build/web/`

**Build output includes:**
- `index.html` - Main HTML file
- `main.dart.js` - Compiled JavaScript code
- `flutter.js` - Flutter framework
- `assets/` - Application assets (fonts, images, etc.)
- `canvaskit/` - Canvas rendering library
- `icons/` - App icons
- Other supporting files

### Step 2: Verify Build Output

```bash
# List build directory contents
ls -la build/web/

# Optional: Test locally before deploying
cd build/web
python3 -m http.server 8000
# Visit http://localhost:8000 in browser
# Press Ctrl+C to stop server
```

### Step 3A: Deploy Using FileZilla (GUI Method)

**Recommended for beginners and Windows users**

1. **Install FileZilla Client**
   - Download from: https://filezilla-project.org/download.php?type=client
   - Install the application

2. **Connect to Your Server**
   ```
   Host:     sftp://YOUR_SERVER_IP
   Username: YOUR_USERNAME
   Password: YOUR_PASSWORD
   Port:     22
   ```
   - Click "Quickconnect"

3. **Navigate to Directories**
   - Local site (left): Navigate to `build/web/` directory
   - Remote site (right): Navigate to `/var/www/html/`

4. **Upload Files**
   - Select all files in local `build/web/` directory
   - Right-click → Upload
   - Wait for transfer to complete
   - Verify all files are uploaded

5. **Verify Structure on Server**
   ```
   /var/www/html/
   ├── index.html
   ├── main.dart.js
   ├── flutter.js
   ├── assets/
   ├── canvaskit/
   ├── icons/
   └── ...
   ```

### Step 3B: Deploy Using SCP (Command Line Method)

**Recommended for Linux/macOS users and automation**

```bash
# Navigate to project directory
cd /path/to/eee4482

# Upload all files using SCP
scp -r build/web/* username@server-ip:/var/www/html/

# Example:
scp -r build/web/* centos@192.168.1.100:/var/www/html/
```

**For multiple deployments, create a deployment script:**

```bash
#!/bin/bash
# deploy-web.sh

SERVER_USER="centos"
SERVER_IP="192.168.1.100"
SERVER_PATH="/var/www/html/"

echo "Building Flutter web app..."
flutter build web --release

echo "Deploying to server..."
scp -r build/web/* $SERVER_USER@$SERVER_IP:$SERVER_PATH

echo "Deployment complete!"
echo "Visit: http://$SERVER_IP"
```

Make it executable:
```bash
chmod +x deploy-web.sh
./deploy-web.sh
```

### Step 3C: Deploy Using rsync (Advanced Method)

**Benefits:** Faster updates, only transfers changed files

```bash
# Install rsync if not available
# Linux: sudo apt-get install rsync
# macOS: (usually pre-installed)

# Sync files to server
rsync -avz --delete build/web/ username@server-ip:/var/www/html/

# Example:
rsync -avz --delete build/web/ centos@192.168.1.100:/var/www/html/
```

**Options explained:**
- `-a`: Archive mode (preserves permissions, timestamps)
- `-v`: Verbose output
- `-z`: Compress during transfer
- `--delete`: Remove files on server that don't exist locally

### Step 4: Configure Apache (if needed)

If the application doesn't load correctly, you may need to configure Apache:

1. **SSH into your server**
   ```bash
   ssh username@server-ip
   ```

2. **Edit Apache configuration**
   ```bash
   sudo nano /etc/httpd/conf/httpd.conf
   ```

3. **Ensure DocumentRoot is correct**
   ```apache
   DocumentRoot "/var/www/html"
   
   <Directory "/var/www/html">
       Options Indexes FollowSymLinks
       AllowOverride All
       Require all granted
   </Directory>
   ```

4. **Create .htaccess for Flutter routing** (if using routes)
   ```bash
   sudo nano /var/www/html/.htaccess
   ```
   
   Add:
   ```apache
   <IfModule mod_rewrite.c>
     RewriteEngine On
     RewriteBase /
     RewriteRule ^index\.html$ - [L]
     RewriteCond %{REQUEST_FILENAME} !-f
     RewriteCond %{REQUEST_FILENAME} !-d
     RewriteRule . /index.html [L]
   </IfModule>
   ```

5. **Set proper permissions**
   ```bash
   sudo chown -R apache:apache /var/www/html
   sudo chmod -R 755 /var/www/html
   ```

6. **Restart Apache**
   ```bash
   sudo systemctl restart httpd
   ```

### Step 5: Test the Deployment

1. **Open your browser**
2. **Navigate to:** `http://YOUR_SERVER_IP/`
3. **Verify:**
   - ✅ Application loads without errors
   - ✅ Navigation works correctly
   - ✅ Student information displays: "HE HUALIANG (230263367)"
   - ✅ All pages are accessible
   - ✅ Book list page functions correctly
   - ✅ Add book page is accessible

---

## Desktop Application Deployment

### Linux Desktop

1. **Build the application**
   ```bash
   flutter build linux --release
   ```

2. **Package location**
   ```
   build/linux/x64/release/bundle/
   ```

3. **Distribution methods:**

   **Method A: Direct folder sharing**
   - Zip the entire `bundle/` folder
   - Share the zip file
   - Users extract and run `eee4482_flutter_app1`

   **Method B: Create .deb package (Ubuntu/Debian)**
   ```bash
   # Install package creation tools
   sudo apt-get install dpkg-dev
   
   # Create package structure
   mkdir -p eee4482-elibrary-1.0/usr/local/bin
   cp -r build/linux/x64/release/bundle/* eee4482-elibrary-1.0/usr/local/bin/
   
   # Create DEBIAN/control file
   mkdir -p eee4482-elibrary-1.0/DEBIAN
   cat > eee4482-elibrary-1.0/DEBIAN/control << EOF
   Package: eee4482-elibrary
   Version: 1.0
   Architecture: amd64
   Maintainer: HE HUALIANG <your-email@example.com>
   Description: EEE4482 e-Library Application
    A Flutter-based e-library management system.
   EOF
   
   # Build package
   dpkg-deb --build eee4482-elibrary-1.0
   ```

### macOS Desktop

1. **Build the application**
   ```bash
   flutter build macos --release
   ```

2. **Package location**
   ```
   build/macos/Build/Products/Release/eee4482_flutter_app1.app
   ```

3. **Distribution methods:**

   **Method A: Direct .app sharing**
   - Zip the `.app` file
   - Share the zip file
   - Users extract and drag to Applications folder

   **Method B: Create DMG installer**
   ```bash
   # Create a temporary directory
   mkdir dmg-contents
   cp -r build/macos/Build/Products/Release/eee4482_flutter_app1.app dmg-contents/
   
   # Create DMG
   hdiutil create -volname "EEE4482 e-Library" -srcfolder dmg-contents -ov -format UDZO eee4482-elibrary-1.0.dmg
   ```

### Windows Desktop

1. **Build the application**
   ```bash
   flutter build windows --release
   ```

2. **Package location**
   ```
   build/windows/x64/runner/Release/
   ```

3. **Distribution methods:**

   **Method A: Direct folder sharing**
   - Zip the entire `Release/` folder
   - Share the zip file
   - Users extract and run `eee4482_flutter_app1.exe`

   **Method B: Create installer using Inno Setup**
   - Download Inno Setup: https://jrsoftware.org/isinfo.php
   - Create an installer script
   - Build installer executable

---

## GitHub Actions Deployment

### Automated Builds

Use GitHub Actions for automatic builds without local Flutter installation.

1. **Navigate to GitHub Actions**
   ```
   https://github.com/TerryNex/eee4482/actions
   ```

2. **Select "Flutter Multi-Platform Build"**

3. **Run Workflow**
   - Click "Run workflow"
   - Select platform: Web, Linux, macOS, or Windows
   - Click "Run workflow"

4. **Wait for Build** (5-15 minutes)

5. **Download Artifacts**
   - Click on completed workflow run
   - Scroll to "Artifacts" section
   - Download your platform build
   - Extract the zip file

6. **Deploy**
   - Follow deployment steps above for your platform
   - Use the downloaded build files

### Automatic Deployment (Advanced)

You can extend the workflow to automatically deploy to your server:

```yaml
# Add to .github/workflows/flutter-build.yml

- name: Deploy to Server
  if: github.event.inputs.platform == 'web'
  run: |
    scp -r build/web/* ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_IP }}:/var/www/html/
  env:
    SSH_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
```

Note: Requires setting up GitHub Secrets for credentials.

---

## Post-Deployment Verification

### Web Application Checklist

- [ ] Open browser and navigate to `http://YOUR_SERVER_IP/`
- [ ] Application loads without 404 errors
- [ ] Home page displays with student info
- [ ] Navigation bar functions correctly
- [ ] Can navigate to "Add Book" page
- [ ] Can navigate to "Book List" page
- [ ] No JavaScript console errors
- [ ] Responsive design works (test different window sizes)
- [ ] Browser back/forward buttons work correctly

### Desktop Application Checklist

- [ ] Application launches without errors
- [ ] All UI elements render correctly
- [ ] Navigation between pages works
- [ ] Can add books (if backend is configured)
- [ ] Can view book list (if backend is configured)
- [ ] Window resizing works properly
- [ ] Application can be closed normally

### Performance Verification

```bash
# Test loading speed
curl -w "@curl-format.txt" -o /dev/null -s http://YOUR_SERVER_IP/

# curl-format.txt content:
time_namelookup:  %{time_namelookup}\n
time_connect:  %{time_connect}\n
time_starttransfer:  %{time_starttransfer}\n
time_total:  %{time_total}\n
```

---

## Common Issues

### Issue: 404 Not Found

**Symptoms:** Browser shows "404 Not Found" error

**Solutions:**
1. Verify files are in correct directory: `/var/www/html/`
2. Check Apache is running: `sudo systemctl status httpd`
3. Verify Apache DocumentRoot configuration
4. Check file permissions: `ls -la /var/www/html/`

### Issue: Blank White Page

**Symptoms:** Page loads but shows nothing

**Solutions:**
1. Check browser console for JavaScript errors (F12)
2. Verify all files uploaded correctly
3. Check `main.dart.js` file exists and is not corrupted
4. Clear browser cache and reload (Ctrl+F5)
5. Test in incognito/private browsing mode

### Issue: Routes Don't Work

**Symptoms:** Direct URLs show 404, only homepage works

**Solutions:**
1. Create `.htaccess` file (see Step 4 above)
2. Enable mod_rewrite: `sudo a2enmod rewrite` (Ubuntu/Debian)
3. Restart Apache: `sudo systemctl restart httpd`

### Issue: Assets Not Loading

**Symptoms:** Images, fonts missing

**Solutions:**
1. Verify `assets/` directory uploaded
2. Check assets path in code
3. Verify MIME types in Apache configuration
4. Check browser console for 404 errors on assets

### Issue: CORS Errors

**Symptoms:** API calls fail with CORS errors

**Solutions:**
1. Configure backend server to allow CORS
2. Add CORS headers in Apache:
   ```apache
   Header set Access-Control-Allow-Origin "*"
   Header set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
   Header set Access-Control-Allow-Headers "Content-Type"
   ```
3. Ensure API and web app on same domain/port in production

### Issue: Large Initial Load Time

**Symptoms:** Application takes long to load first time

**Solutions:**
1. Enable gzip compression in Apache:
   ```apache
   <IfModule mod_deflate.c>
     AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css text/javascript application/javascript
   </IfModule>
   ```
2. Enable browser caching:
   ```apache
   <IfModule mod_expires.c>
     ExpiresActive On
     ExpiresByType image/jpg "access plus 1 year"
     ExpiresByType image/jpeg "access plus 1 year"
     ExpiresByType image/png "access plus 1 year"
     ExpiresByType text/css "access plus 1 month"
     ExpiresByType application/javascript "access plus 1 month"
   </IfModule>
   ```
3. Use `--web-renderer html` instead of `canvaskit` for faster loading:
   ```bash
   flutter build web --release --web-renderer html
   ```

---

## Deployment Best Practices

1. **Always test builds locally** before deploying
2. **Keep backups** of previous deployments
3. **Use version tags** in git for tracking deployments
4. **Document any server configurations** made
5. **Test on multiple browsers** (Chrome, Firefox, Safari, Edge)
6. **Monitor server logs** for errors after deployment
7. **Use HTTPS** in production (configure SSL/TLS certificate)

---

## Need Help?

- **Project README:** See [README.md](README.md)
- **Quick Start:** See [QUICKSTART.md](QUICKSTART.md)
- **Flutter Docs:** https://docs.flutter.dev/deployment
- **Apache Docs:** https://httpd.apache.org/docs/

---

**Last Updated:** 2025-11-01  
**Maintained by:** HE HUALIANG (230263367)
