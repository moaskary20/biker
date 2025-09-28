#!/bin/bash

# سكريبت شامل لإصلاح مشكلة الصور على السيرفر الخارجي
# Complete Image Fix Script for https://biker.caesar-agency.com

echo "🔧 بدء الإصلاح الشامل لمشكلة الصور..."
echo "Starting comprehensive image fix process..."

# الانتقال إلى مجلد المشروع
cd /var/www/biker

echo ""
echo "📋 الخطوة 1: فحص الوضع الحالي"
echo "Step 1: Checking current status"

echo "فحص مجلد storage..."
echo "Checking storage directory..."
if [ -d "storage/app/public" ]; then
    echo "✅ مجلد storage/app/public موجود"
    echo "storage/app/public directory exists"
    ls -la storage/app/public/
else
    echo "❌ مجلد storage/app/public غير موجود"
    echo "storage/app/public directory does not exist"
    exit 1
fi

echo ""
echo "فحص مجلد الصور..."
echo "Checking images directory..."
if [ -d "storage/app/public/blog/categories" ]; then
    IMAGE_COUNT=$(ls -1 storage/app/public/blog/categories/*.jpg 2>/dev/null | wc -l)
    echo "✅ عدد الصور الموجودة: $IMAGE_COUNT"
    echo "Number of images found: $IMAGE_COUNT"
    ls -la storage/app/public/blog/categories/
else
    echo "❌ مجلد الصور غير موجود"
    echo "Images directory does not exist"
    mkdir -p storage/app/public/blog/categories
    echo "✅ تم إنشاء مجلد الصور"
    echo "Images directory created"
fi

echo ""
echo "فحص الـ symbolic link..."
echo "Checking symbolic link..."
if [ -L "public/storage" ]; then
    echo "✅ الـ symbolic link موجود"
    echo "Symbolic link exists"
    ls -la public/storage
else
    echo "❌ الـ symbolic link غير موجود"
    echo "Symbolic link does not exist"
fi

echo ""
echo "📋 الخطوة 2: إصلاح الـ symbolic link"
echo "Step 2: Fixing symbolic link"

echo "حذف الـ symbolic link القديم..."
echo "Removing old symbolic link..."
rm -f public/storage
rm -rf public/storage

echo "إنشاء مجلد public/storage..."
echo "Creating public/storage directory..."
mkdir -p public/storage

echo "إنشاء الـ symbolic link جديد..."
echo "Creating new symbolic link..."
ln -sf ../storage/app/public public/storage

echo "التحقق من الـ symbolic link الجديد..."
echo "Checking new symbolic link..."
if [ -L "public/storage" ]; then
    echo "✅ تم إنشاء الـ symbolic link بنجاح"
    echo "Symbolic link created successfully"
    ls -la public/storage
else
    echo "❌ فشل في إنشاء الـ symbolic link"
    echo "Failed to create symbolic link"
    
    # محاولة بديلة
    echo "محاولة بديلة..."
    echo "Alternative attempt..."
    rm -rf public/storage
    php artisan storage:link
    
    if [ -L "public/storage" ]; then
        echo "✅ تم إنشاء الـ symbolic link بالطريقة البديلة"
        echo "Symbolic link created using alternative method"
        ls -la public/storage
    else
        echo "❌ فشل في إنشاء الـ symbolic link بالطرق المتاحة"
        echo "Failed to create symbolic link with available methods"
        exit 1
    fi
fi

echo ""
echo "📋 الخطوة 3: تحديث APP_URL"
echo "Step 3: Updating APP_URL"

# نسخ احتياطي من ملف .env
cp .env .env.backup.$(date +%Y%m%d_%H%M%S)

# تحديث APP_URL
sed -i 's|APP_URL=.*|APP_URL=https://biker.caesar-agency.com|g' .env

echo "التحقق من APP_URL الجديد..."
echo "Checking new APP_URL..."
APP_URL=$(grep "APP_URL=" .env | cut -d '=' -f2)
echo "APP_URL الجديد: $APP_URL"
echo "New APP_URL: $APP_URL"

if [ "$APP_URL" = "https://biker.caesar-agency.com" ]; then
    echo "✅ APP_URL محدث بنجاح"
    echo "APP_URL updated successfully"
else
    echo "❌ فشل في تحديث APP_URL"
    echo "Failed to update APP_URL"
    exit 1
fi

echo ""
echo "📋 الخطوة 4: مسح جميع أنواع الكاش"
echo "Step 4: Clearing all types of cache"

echo "مسح config cache..."
echo "Clearing config cache..."
php artisan config:clear

echo "مسح application cache..."
echo "Clearing application cache..."
php artisan cache:clear

echo "مسح view cache..."
echo "Clearing view cache..."
php artisan view:clear

echo "مسح route cache..."
echo "Clearing route cache..."
php artisan route:clear

echo "مسح bootstrap cache..."
echo "Clearing bootstrap cache..."
php artisan optimize:clear

echo ""
echo "📋 الخطوة 5: إصلاح الصلاحيات"
echo "Step 5: Fixing permissions"

echo "إصلاح صلاحيات مجلد storage..."
echo "Fixing storage directory permissions..."
chmod -R 755 storage/
chmod -R 777 storage/app/public/
chmod -R 777 storage/logs/

echo "إصلاح صلاحيات مجلد public..."
echo "Fixing public directory permissions..."
chmod -R 755 public/
chmod -R 777 public/storage/

echo "إصلاح صلاحيات مجلد bootstrap..."
echo "Fixing bootstrap directory permissions..."
chmod -R 755 bootstrap/cache/

echo ""
echo "📋 الخطوة 6: إعادة تشغيل الخدمات"
echo "Step 6: Restarting services"

echo "إعادة تشغيل PHP-FPM..."
echo "Restarting PHP-FPM..."
systemctl restart php8.1-fpm 2>/dev/null || systemctl restart php8.2-fpm 2>/dev/null || systemctl restart php8.3-fpm 2>/dev/null || echo "PHP-FPM restart skipped"

echo "إعادة تشغيل Nginx..."
echo "Restarting Nginx..."
systemctl restart nginx 2>/dev/null || echo "Nginx restart skipped"

echo ""
echo "📋 الخطوة 7: اختبار الصور"
echo "Step 7: Testing images"

if [ -d "storage/app/public/blog/categories" ]; then
    TEST_IMAGE=$(ls storage/app/public/blog/categories/*.jpg | head -1 | xargs basename)
    if [ ! -z "$TEST_IMAGE" ]; then
        echo "اختبار الصورة: $TEST_IMAGE"
        echo "Testing image: $TEST_IMAGE"
        
        # اختبار الملف المادي
        if [ -f "storage/app/public/blog/categories/$TEST_IMAGE" ]; then
            echo "✅ الصورة موجودة في storage"
            echo "Image exists in storage"
        else
            echo "❌ الصورة غير موجودة في storage"
            echo "Image does not exist in storage"
        fi
        
        # اختبار الـ symbolic link
        if [ -f "public/storage/blog/categories/$TEST_IMAGE" ]; then
            echo "✅ الصورة متاحة عبر الـ symbolic link"
            echo "Image is accessible via symbolic link"
        else
            echo "❌ الصورة غير متاحة عبر الـ symbolic link"
            echo "Image is not accessible via symbolic link"
        fi
        
        # اختبار HTTP
        echo "اختبار HTTP للصورة..."
        echo "Testing HTTP for image..."
        sleep 2  # انتظار قصير للتأكد من إعادة تشغيل الخدمات
        
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://biker.caesar-agency.com/storage/blog/categories/$TEST_IMAGE")
        
        if [ "$HTTP_STATUS" = "200" ]; then
            echo "✅ الصورة متاحة عبر HTTP (Status: $HTTP_STATUS)"
            echo "Image is accessible via HTTP (Status: $HTTP_STATUS)"
        else
            echo "❌ الصورة غير متاحة عبر HTTP (Status: $HTTP_STATUS)"
            echo "Image is not accessible via HTTP (Status: $HTTP_STATUS)"
            
            # محاولة إضافية مع Cloudflare
            echo "محاولة مع Cloudflare cache purge..."
            echo "Attempting with Cloudflare cache purge..."
            
            # إضافة header لتفادي Cloudflare
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
echo "📋 الخطوة 8: إنشاء ملف اختبار"
echo "Step 8: Creating test file"

echo "إنشاء ملف اختبار..."
echo "Creating test file..."
echo "Test file created at $(date)" > public/storage/test.txt

# اختبار الملف
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://biker.caesar-agency.com/storage/test.txt")

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ الـ symbolic link يعمل بشكل صحيح"
    echo "Symbolic link is working correctly"
    rm -f public/storage/test.txt
else
    echo "❌ الـ symbolic link لا يعمل"
    echo "Symbolic link is not working"
    echo "Status: $HTTP_STATUS"
fi

echo ""
echo "📋 الخطوة 9: تقرير نهائي"
echo "Step 9: Final report"

echo "📁 مجلد الصور: storage/app/public/blog/categories/"
echo "Images directory: storage/app/public/blog/categories/"

echo "🔗 الـ symbolic link: public/storage -> storage/app/public"
echo "Symbolic link: public/storage -> storage/app/public"

echo "🌐 APP_URL: https://biker.caesar-agency.com"
echo "APP_URL: https://biker.caesar-agency.com"

echo "🔍 رابط الاختبار: https://biker.caesar-agency.com/storage/blog/categories/[اسم_الصورة]"
echo "Test URL: https://biker.caesar-agency.com/storage/blog/categories/[image_name]"

echo ""
echo "📋 الخطوات الإضافية المطلوبة:"
echo "Additional steps required:"

echo "1. إذا كانت المشكلة مستمرة، تحقق من إعدادات Nginx/Apache"
echo "1. If problem persists, check Nginx/Apache configuration"

echo "2. تأكد من أن web server يمكنه قراءة مجلد public/storage"
echo "2. Ensure web server can read public/storage directory"

echo "3. تحقق من Cloudflare settings وإمسح الكاش"
echo "3. Check Cloudflare settings and purge cache"

echo "4. تأكد من أن SSL certificate صحيح"
echo "4. Ensure SSL certificate is valid"

echo ""
echo "✅ تم الانتهاء من الإصلاح الشامل!"
echo "Comprehensive fix completed!"

echo ""
echo "🎉 انتهى السكريبت!"
echo "Script finished!"
