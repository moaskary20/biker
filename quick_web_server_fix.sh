#!/bin/bash

# سكريبت سريع لإصلاح مشكلة الصور على السيرفر الخارجي
# Quick Web Server Fix Script for Image Issues

echo "🔧 إصلاح سريع لمشكلة الصور..."
echo "Quick fix for image issues..."

cd /var/www/biker

echo ""
echo "📋 الخطوة 1: تحديد نوع الـ Web Server"
echo "Step 1: Identifying web server type"

WEB_SERVER=""
if systemctl is-active --quiet nginx; then
    WEB_SERVER="nginx"
    echo "✅ Nginx detected"
elif systemctl is-active --quiet apache2; then
    WEB_SERVER="apache2"
    echo "✅ Apache2 detected"
else
    echo "❌ No active web server found"
    exit 1
fi

echo ""
echo "📋 الخطوة 2: إصلاح إعدادات $WEB_SERVER"
echo "Step 2: Fixing $WEB_SERVER configuration"

if [ "$WEB_SERVER" = "nginx" ]; then
    # إصلاح Nginx
    echo "إصلاح إعدادات Nginx..."
    
    # البحث عن ملف الإعدادات
    NGINX_CONFIG=""
    if [ -f "/etc/nginx/sites-available/biker.caesar-agency.com" ]; then
        NGINX_CONFIG="/etc/nginx/sites-available/biker.caesar-agency.com"
    elif [ -f "/etc/nginx/sites-available/default" ]; then
        NGINX_CONFIG="/etc/nginx/sites-available/default"
    fi
    
    if [ ! -z "$NGINX_CONFIG" ]; then
        echo "ملف الإعدادات: $NGINX_CONFIG"
        
        # نسخ احتياطي
        cp "$NGINX_CONFIG" "$NGINX_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        
        # إضافة إعدادات storage
        cat >> "$NGINX_CONFIG" << 'EOF'

# Storage configuration for Laravel
location /storage {
    alias /var/www/biker/public/storage;
    expires 1y;
    add_header Cache-Control "public, immutable";
}
EOF
        
        # اختبار وإعادة تحميل
        nginx -t && systemctl reload nginx
        echo "✅ تم إصلاح إعدادات Nginx"
    fi
    
elif [ "$WEB_SERVER" = "apache2" ]; then
    # إصلاح Apache
    echo "إصلاح إعدادات Apache..."
    
    # البحث عن ملف الإعدادات
    APACHE_CONFIG=""
    if [ -f "/etc/apache2/sites-available/biker.caesar-agency.com.conf" ]; then
        APACHE_CONFIG="/etc/apache2/sites-available/biker.caesar-agency.com.conf"
    elif [ -f "/etc/apache2/sites-available/000-default.conf" ]; then
        APACHE_CONFIG="/etc/apache2/sites-available/000-default.conf"
    fi
    
    if [ ! -z "$APACHE_CONFIG" ]; then
        echo "ملف الإعدادات: $APACHE_CONFIG"
        
        # نسخ احتياطي
        cp "$APACHE_CONFIG" "$APACHE_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        
        # إضافة إعدادات storage
        cat >> "$APACHE_CONFIG" << 'EOF'

# Storage configuration for Laravel
Alias /storage /var/www/biker/public/storage
<Directory /var/www/biker/public/storage>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
EOF
        
        # تفعيل mod_rewrite وإعادة تحميل
        a2enmod rewrite
        apache2ctl configtest && systemctl reload apache2
        echo "✅ تم إصلاح إعدادات Apache"
    fi
fi

echo ""
echo "📋 الخطوة 3: إعادة تشغيل الخدمات"
echo "Step 3: Restarting services"

# إعادة تشغيل PHP-FPM
systemctl restart php8.1-fpm 2>/dev/null || systemctl restart php8.2-fpm 2>/dev/null || systemctl restart php8.3-fpm 2>/dev/null

# إعادة تشغيل Web Server
systemctl restart "$WEB_SERVER"

echo ""
echo "📋 الخطوة 4: اختبار الصور"
echo "Step 4: Testing images"

sleep 3

# اختبار صورة عشوائية
if [ -d "storage/app/public/blog/categories" ]; then
    TEST_IMAGE=$(ls storage/app/public/blog/categories/*.jpg | head -1 | xargs basename)
    if [ ! -z "$TEST_IMAGE" ]; then
        echo "اختبار الصورة: $TEST_IMAGE"
        
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://biker.caesar-agency.com/storage/blog/categories/$TEST_IMAGE")
        
        if [ "$HTTP_STATUS" = "200" ]; then
            echo "✅ الصورة متاحة الآن! (Status: $HTTP_STATUS)"
            echo "Images are now accessible! (Status: $HTTP_STATUS)"
        else
            echo "❌ الصورة لا تزال غير متاحة (Status: $HTTP_STATUS)"
            echo "Images are still not accessible (Status: $HTTP_STATUS)"
            echo "⚠️  المشكلة قد تكون في Cloudflare cache"
            echo "Issue might be with Cloudflare cache"
        fi
    fi
fi

echo ""
echo "📋 الخطوة 5: فحص Cloudflare"
echo "Step 5: Checking Cloudflare"

# فحص Cloudflare
CF_HEADER=$(curl -s -I "https://biker.caesar-agency.com" | grep -i "cf-")
if [ ! -z "$CF_HEADER" ]; then
    echo "✅ الموقع يستخدم Cloudflare"
    echo "Site is using Cloudflare"
    echo ""
    echo "⚠️  يجب مسح كاش Cloudflare:"
    echo "Cloudflare cache should be purged:"
    echo "1. ادخل إلى Cloudflare Dashboard"
    echo "2. اختر الموقع: biker.caesar-agency.com"
    echo "3. اذهب إلى Caching → Configuration"
    echo "4. اضغط Purge Everything"
else
    echo "❌ الموقع لا يستخدم Cloudflare"
    echo "Site is not using Cloudflare"
fi

echo ""
echo "✅ تم الانتهاء من الإصلاح السريع!"
echo "Quick fix completed!"

if [ "$HTTP_STATUS" = "200" ]; then
    echo "🎉 المشكلة تم حلها!"
    echo "Problem solved!"
else
    echo "📋 الخطوات التالية:"
    echo "Next steps:"
    echo "1. مسح كاش Cloudflare (إذا كان مستخدماً)"
    echo "2. انتظار 5-10 دقائق"
    echo "3. اختبار الصور مرة أخرى"
fi

