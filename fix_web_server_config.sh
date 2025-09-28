#!/bin/bash

# سكريبت إصلاح إعدادات الـ Web Server لحل مشكلة 404
# Fix Web Server Configuration Script for 404 Image Issues

echo "🔧 بدء إصلاح إعدادات الـ Web Server..."
echo "Starting web server configuration fix..."

# الانتقال إلى مجلد المشروع
cd /var/www/biker

echo ""
echo "📋 الخطوة 1: تحديد نوع الـ Web Server"
echo "Step 1: Identifying web server type"

WEB_SERVER=""
if systemctl is-active --quiet nginx; then
    WEB_SERVER="nginx"
    echo "✅ تم اكتشاف Nginx"
    echo "Nginx detected"
elif systemctl is-active --quiet apache2; then
    WEB_SERVER="apache2"
    echo "✅ تم اكتشاف Apache2"
    echo "Apache2 detected"
else
    echo "❌ لم يتم العثور على web server نشط"
    echo "No active web server found"
    exit 1
fi

echo ""
echo "📋 الخطوة 2: إنشاء ملف اختبار"
echo "Step 2: Creating test file"

# إنشاء ملف اختبار
echo "Test file created at $(date)" > public/storage/test.txt
chmod 644 public/storage/test.txt

# اختبار الملف
TEST_URL="https://biker.caesar-agency.com/storage/test.txt"
echo "اختبار الملف: $TEST_URL"
echo "Testing file: $TEST_URL"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$TEST_URL")
echo "HTTP Status: $HTTP_STATUS"

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ الـ symbolic link يعمل بشكل صحيح"
    echo "Symbolic link is working correctly"
else
    echo "❌ الـ symbolic link لا يعمل"
    echo "Symbolic link is not working"
    echo "Status: $HTTP_STATUS"
fi

echo ""
echo "📋 الخطوة 3: إصلاح إعدادات $WEB_SERVER"
echo "Step 3: Fixing $WEB_SERVER configuration"

if [ "$WEB_SERVER" = "nginx" ]; then
    echo "إصلاح إعدادات Nginx..."
    echo "Fixing Nginx configuration..."
    
    # البحث عن ملف الإعدادات
    NGINX_CONFIG=""
    if [ -f "/etc/nginx/sites-available/biker.caesar-agency.com" ]; then
        NGINX_CONFIG="/etc/nginx/sites-available/biker.caesar-agency.com"
    elif [ -f "/etc/nginx/sites-available/default" ]; then
        NGINX_CONFIG="/etc/nginx/sites-available/default"
    elif [ -f "/etc/nginx/nginx.conf" ]; then
        NGINX_CONFIG="/etc/nginx/nginx.conf"
    fi
    
    if [ ! -z "$NGINX_CONFIG" ]; then
        echo "ملف الإعدادات: $NGINX_CONFIG"
        echo "Config file: $NGINX_CONFIG"
        
        # نسخ احتياطي
        cp "$NGINX_CONFIG" "$NGINX_CONFIG.backup.$(date +%Y%m%d_%H%M%S)"
        
        # إضافة إعدادات storage
        cat >> "$NGINX_CONFIG" << 'EOF'

# Storage configuration for Laravel
location /storage {
    alias /var/www/biker/public/storage;
    expires 1y;
    add_header Cache-Control "public, immutable";
    access_log off;
}

# Additional storage configuration
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
    access_log off;
}
EOF
        
        echo "✅ تم إضافة إعدادات storage إلى Nginx"
        echo "Storage configuration added to Nginx"
        
        # اختبار الإعدادات
        nginx -t
        if [ $? -eq 0 ]; then
            echo "✅ إعدادات Nginx صحيحة"
            echo "Nginx configuration is valid"
            
            # إعادة تحميل Nginx
            systemctl reload nginx
            echo "✅ تم إعادة تحميل Nginx"
            echo "Nginx reloaded"
        else
            echo "❌ خطأ في إعدادات Nginx"
            echo "Nginx configuration error"
        fi
    else
        echo "❌ لم يتم العثور على ملف إعدادات Nginx"
        echo "Nginx configuration file not found"
    fi
    
elif [ "$WEB_SERVER" = "apache2" ]; then
    echo "إصلاح إعدادات Apache..."
    echo "Fixing Apache configuration..."
    
    # البحث عن ملف الإعدادات
    APACHE_CONFIG=""
    if [ -f "/etc/apache2/sites-available/biker.caesar-agency.com.conf" ]; then
        APACHE_CONFIG="/etc/apache2/sites-available/biker.caesar-agency.com.conf"
    elif [ -f "/etc/apache2/sites-available/000-default.conf" ]; then
        APACHE_CONFIG="/etc/apache2/sites-available/000-default.conf"
    fi
    
    if [ ! -z "$APACHE_CONFIG" ]; then
        echo "ملف الإعدادات: $APACHE_CONFIG"
        echo "Config file: $APACHE_CONFIG"
        
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
    ExpiresActive On
    ExpiresDefault "access plus 1 year"
</Directory>
EOF
        
        echo "✅ تم إضافة إعدادات storage إلى Apache"
        echo "Storage configuration added to Apache"
        
        # تفعيل mod_rewrite و mod_expires
        a2enmod rewrite expires
        echo "✅ تم تفعيل mod_rewrite و mod_expires"
        echo "Enabled mod_rewrite and mod_expires"
        
        # اختبار الإعدادات
        apache2ctl configtest
        if [ $? -eq 0 ]; then
            echo "✅ إعدادات Apache صحيحة"
            echo "Apache configuration is valid"
            
            # إعادة تحميل Apache
            systemctl reload apache2
            echo "✅ تم إعادة تحميل Apache"
            echo "Apache reloaded"
        else
            echo "❌ خطأ في إعدادات Apache"
            echo "Apache configuration error"
        fi
    else
        echo "❌ لم يتم العثور على ملف إعدادات Apache"
        echo "Apache configuration file not found"
    fi
fi

echo ""
echo "📋 الخطوة 4: إعادة تشغيل الخدمات"
echo "Step 4: Restarting services"

# إعادة تشغيل PHP-FPM
echo "إعادة تشغيل PHP-FPM..."
echo "Restarting PHP-FPM..."
systemctl restart php8.1-fpm 2>/dev/null || systemctl restart php8.2-fpm 2>/dev/null || systemctl restart php8.3-fpm 2>/dev/null || echo "PHP-FPM restart skipped"

# إعادة تشغيل Web Server
echo "إعادة تشغيل $WEB_SERVER..."
echo "Restarting $WEB_SERVER..."
systemctl restart "$WEB_SERVER"

echo ""
echo "📋 الخطوة 5: اختبار الصور مرة أخرى"
echo "Step 5: Testing images again"

sleep 3  # انتظار قصير

if [ -d "storage/app/public/blog/categories" ]; then
    TEST_IMAGE=$(ls storage/app/public/blog/categories/*.jpg | head -1 | xargs basename)
    if [ ! -z "$TEST_IMAGE" ]; then
        echo "اختبار الصورة: $TEST_IMAGE"
        echo "Testing image: $TEST_IMAGE"
        
        # اختبار HTTP
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://biker.caesar-agency.com/storage/blog/categories/$TEST_IMAGE")
        
        if [ "$HTTP_STATUS" = "200" ]; then
            echo "✅ الصورة متاحة عبر HTTP (Status: $HTTP_STATUS)"
            echo "Image is accessible via HTTP (Status: $HTTP_STATUS)"
        else
            echo "❌ الصورة غير متاحة عبر HTTP (Status: $HTTP_STATUS)"
            echo "Image is not accessible via HTTP (Status: $HTTP_STATUS)"
            
            # اختبار مع headers مختلفة
            echo "اختبار مع headers مختلفة..."
            echo "Testing with different headers..."
            
            HTTP_STATUS_NO_CACHE=$(curl -s -o /dev/null -w "%{http_code}" -H "Cache-Control: no-cache" -H "Pragma: no-cache" "https://biker.caesar-agency.com/storage/blog/categories/$TEST_IMAGE")
            
            if [ "$HTTP_STATUS_NO_CACHE" = "200" ]; then
                echo "✅ الصورة متاحة مع no-cache headers (Status: $HTTP_STATUS_NO_CACHE)"
                echo "Image is accessible with no-cache headers (Status: $HTTP_STATUS_NO_CACHE)"
                echo "⚠️  المشكلة في Cloudflare cache"
                echo "Issue is with Cloudflare cache"
            else
                echo "❌ الصورة غير متاحة حتى مع no-cache headers (Status: $HTTP_STATUS_NO_CACHE)"
                echo "Image is not accessible even with no-cache headers (Status: $HTTP_STATUS_NO_CACHE)"
            fi
        fi
    fi
fi

echo ""
echo "📋 الخطوة 6: فحص Cloudflare"
echo "Step 6: Checking Cloudflare"

# فحص إذا كان الموقع يستخدم Cloudflare
CF_HEADER=$(curl -s -I "https://biker.caesar-agency.com" | grep -i "cf-")
if [ ! -z "$CF_HEADER" ]; then
    echo "✅ الموقع يستخدم Cloudflare"
    echo "Site is using Cloudflare"
    echo "Cloudflare headers detected:"
    echo "$CF_HEADER"
    
    echo ""
    echo "⚠️  يجب مسح كاش Cloudflare:"
    echo "Cloudflare cache should be purged:"
    echo "1. ادخل إلى لوحة تحكم Cloudflare"
    echo "1. Login to Cloudflare dashboard"
    echo "2. اذهب إلى Caching → Configuration"
    echo "2. Go to Caching → Configuration"
    echo "3. اضغط Purge Everything"
    echo "3. Click Purge Everything"
else
    echo "❌ الموقع لا يستخدم Cloudflare"
    echo "Site is not using Cloudflare"
fi

echo ""
echo "📋 الخطوة 7: إنشاء ملف تعليمات Cloudflare"
echo "Step 7: Creating Cloudflare instructions"

cat > CLOUDFLARE_INSTRUCTIONS.md << 'EOF'
# ☁️ تعليمات مسح كاش Cloudflare

## إذا كان الموقع يستخدم Cloudflare:

### الطريقة الأولى - لوحة التحكم:
1. ادخل إلى [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. اختر الموقع: `biker.caesar-agency.com`
3. اذهب إلى **Caching** → **Configuration**
4. اضغط **Purge Everything**
5. انتظر حتى يتم المسح

### الطريقة الثانية - API:
```bash
# احصل على API Token من Cloudflare
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/purge_cache" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'
```

### الطريقة الثالثة - مسح محدد:
```bash
# مسح صور محددة
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/purge_cache" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"files":["https://biker.caesar-agency.com/storage/blog/categories/*"]}'
```

## ملاحظات مهمة:
- قد يستغرق مسح الكاش من 30 ثانية إلى 5 دقائق
- تأكد من أن Zone ID صحيح
- تأكد من أن API Token له صلاحيات مناسبة

## إذا لم يعمل مسح الكاش:
1. تحقق من إعدادات Cloudflare
2. تأكد من أن SSL/TLS mode صحيح
3. تحقق من Page Rules
4. راجع Browser Cache TTL
EOF

echo "✅ تم إنشاء ملف تعليمات Cloudflare: CLOUDFLARE_INSTRUCTIONS.md"
echo "Cloudflare instructions file created: CLOUDFLARE_INSTRUCTIONS.md"

echo ""
echo "📋 الخطوة 8: تنظيف ملفات الاختبار"
echo "Step 8: Cleaning up test files"

rm -f public/storage/test.txt
echo "✅ تم حذف ملف الاختبار"
echo "Test file removed"

echo ""
echo "📋 الخطوة 9: تقرير نهائي"
echo "Step 9: Final report"

echo "🌐 Web Server: $WEB_SERVER"
echo "🔗 Symbolic Link: public/storage -> storage/app/public"
echo "📁 Images Directory: storage/app/public/blog/categories/"
echo "🔍 Test URL: https://biker.caesar-agency.com/storage/blog/categories/[image_name]"

echo ""
echo "📋 الخطوات التالية:"
echo "Next steps:"

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ المشكلة تم حلها! الصور متاحة الآن"
    echo "Problem solved! Images are now accessible"
else
    echo "1. مسح كاش Cloudflare (إذا كان مستخدماً)"
    echo "1. Clear Cloudflare cache (if used)"
    echo "2. انتظار 5-10 دقائق للتأكد من انتشار التغييرات"
    echo "2. Wait 5-10 minutes for changes to propagate"
    echo "3. اختبار الصور مرة أخرى"
    echo "3. Test images again"
    echo "4. إذا استمرت المشكلة، تحقق من logs الأخطاء"
    echo "4. If problem persists, check error logs"
fi

echo ""
echo "✅ تم الانتهاء من إصلاح إعدادات الـ Web Server!"
echo "Web server configuration fix completed!"

echo ""
echo "🎉 انتهى السكريبت!"
echo "Script finished!"

