#!/bin/bash

# سكريبت إصلاح مشكلة الصور على السيرفر الخارجي
# Fix Server Images Script for https://biker.caesar-agency.com

echo "🔧 بدء إصلاح مشكلة الصور على السيرفر الخارجي..."
echo "Starting image fix process for external server..."

# الانتقال إلى مجلد المشروع
cd /var/www/biker

echo ""
echo "1️⃣ التحقق من الـ Symbolic Link الحالي..."
echo "Checking current symbolic link..."

if [ -L "public/storage" ]; then
    echo "✅ الـ symbolic link موجود:"
    echo "Symbolic link exists:"
    ls -la public/storage
else
    echo "❌ الـ symbolic link غير موجود"
    echo "Symbolic link does not exist"
fi

echo ""
echo "2️⃣ حذف الـ symbolic link القديم (إن وجد)..."
echo "Removing old symbolic link (if exists)..."

rm -f public/storage

echo ""
echo "3️⃣ إنشاء الـ symbolic link جديد..."
echo "Creating new symbolic link..."

php artisan storage:link

echo ""
echo "4️⃣ التحقق من الـ Symbolic Link الجديد..."
echo "Checking new symbolic link..."

if [ -L "public/storage" ]; then
    echo "✅ تم إنشاء الـ symbolic link بنجاح:"
    echo "Symbolic link created successfully:"
    ls -la public/storage
else
    echo "❌ فشل في إنشاء الـ symbolic link"
    echo "Failed to create symbolic link"
    exit 1
fi

echo ""
echo "5️⃣ التحقق من APP_URL في ملف .env..."
echo "Checking APP_URL in .env file..."

APP_URL=$(grep "APP_URL=" .env | cut -d '=' -f2)
echo "APP_URL الحالي: $APP_URL"
echo "Current APP_URL: $APP_URL"

if [ "$APP_URL" != "https://biker.caesar-agency.com" ]; then
    echo "⚠️  APP_URL غير صحيح، يتم تصحيحه..."
    echo "APP_URL is incorrect, fixing..."
    
    # نسخ احتياطي من ملف .env
    cp .env .env.backup
    
    # تحديث APP_URL
    sed -i 's|APP_URL=.*|APP_URL=https://biker.caesar-agency.com|g' .env
    
    echo "✅ تم تحديث APP_URL إلى: https://biker.caesar-agency.com"
    echo "APP_URL updated to: https://biker.caesar-agency.com"
else
    echo "✅ APP_URL صحيح بالفعل"
    echo "APP_URL is already correct"
fi

echo ""
echo "6️⃣ مسح جميع أنواع الكاش..."
echo "Clearing all types of cache..."

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

echo ""
echo "7️⃣ إصلاح صلاحيات الملفات..."
echo "Fixing file permissions..."

echo "إصلاح صلاحيات مجلد storage..."
echo "Fixing storage directory permissions..."
chmod -R 755 storage/
chown -R www-data:www-data storage/

echo "إصلاح صلاحيات مجلد public..."
echo "Fixing public directory permissions..."
chmod -R 755 public/
chown -R www-data:www-data public/

echo ""
echo "8️⃣ التحقق من وجود الصور..."
echo "Checking if images exist..."

if [ -d "storage/app/public/blog/categories" ]; then
    IMAGE_COUNT=$(ls -1 storage/app/public/blog/categories/*.jpg 2>/dev/null | wc -l)
    echo "✅ عدد صور المدونات الموجودة: $IMAGE_COUNT"
    echo "Number of blog images found: $IMAGE_COUNT"
    
    if [ $IMAGE_COUNT -gt 0 ]; then
        echo "أمثلة على الصور الموجودة:"
        echo "Examples of existing images:"
        ls -1 storage/app/public/blog/categories/*.jpg | head -3
    fi
else
    echo "❌ مجلد صور المدونات غير موجود"
    echo "Blog images directory does not exist"
fi

echo ""
echo "9️⃣ اختبار صورة عشوائية..."
echo "Testing a random image..."

if [ -d "storage/app/public/blog/categories" ]; then
    TEST_IMAGE=$(ls storage/app/public/blog/categories/*.jpg | head -1 | xargs basename)
    if [ ! -z "$TEST_IMAGE" ]; then
        echo "اختبار الصورة: $TEST_IMAGE"
        echo "Testing image: $TEST_IMAGE"
        
        if [ -f "public/storage/blog/categories/$TEST_IMAGE" ]; then
            echo "✅ الصورة متاحة عبر الـ symbolic link"
            echo "Image is accessible via symbolic link"
            
            # اختبار HTTP
            echo "اختبار HTTP للصورة..."
            echo "Testing HTTP for image..."
            HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://biker.caesar-agency.com/storage/blog/categories/$TEST_IMAGE")
            
            if [ "$HTTP_STATUS" = "200" ]; then
                echo "✅ الصورة متاحة عبر HTTP (Status: $HTTP_STATUS)"
                echo "Image is accessible via HTTP (Status: $HTTP_STATUS)"
            else
                echo "❌ الصورة غير متاحة عبر HTTP (Status: $HTTP_STATUS)"
                echo "Image is not accessible via HTTP (Status: $HTTP_STATUS)"
            fi
        else
            echo "❌ الصورة غير متاحة عبر الـ symbolic link"
            echo "Image is not accessible via symbolic link"
        fi
    fi
fi

echo ""
echo "🔟 ملخص النتائج..."
echo "Summary of results..."

echo "📁 مجلد الصور: storage/app/public/blog/categories/"
echo "Images directory: storage/app/public/blog/categories/"

echo "🔗 الـ symbolic link: public/storage -> storage/app/public"
echo "Symbolic link: public/storage -> storage/app/public"

echo "🌐 APP_URL: https://biker.caesar-agency.com"
echo "APP_URL: https://biker.caesar-agency.com"

echo "🔍 رابط الاختبار: https://biker.caesar-agency.com/storage/blog/categories/[اسم_الصورة]"
echo "Test URL: https://biker.caesar-agency.com/storage/blog/categories/[image_name]"

echo ""
echo "✅ تم الانتهاء من إصلاح مشكلة الصور!"
echo "Image fix process completed!"

echo ""
echo "📋 الخطوات التالية:"
echo "Next steps:"
echo "1. اختبر الصور في صفحة إدارة المدونة: https://biker.caesar-agency.com/admin/blog/categories"
echo "1. Test images in blog management page: https://biker.caesar-agency.com/admin/blog/categories"
echo "2. اختبر الصور في تطبيق الموبايل"
echo "2. Test images in mobile application"
echo "3. إذا كانت المشكلة مستمرة، تحقق من إعدادات الـ web server"
echo "3. If problem persists, check web server configuration"

echo ""
echo "🎉 انتهى السكريبت!"
echo "Script finished!"
