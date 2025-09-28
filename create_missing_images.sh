#!/bin/bash

# سكريبت إنشاء الصور المفقودة على السيرفر الخارجي
# Create Missing Images Script for External Server

echo "🔧 بدء إنشاء الصور المفقودة على السيرفر الخارجي..."
echo "Starting creation of missing images on external server..."

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
else
    echo "❌ مجلد storage/app/public غير موجود"
    echo "storage/app/public directory does not exist"
    echo "إنشاء المجلد..."
    echo "Creating directory..."
    mkdir -p storage/app/public
    chmod -R 777 storage/
fi

echo ""
echo "فحص مجلد الصور..."
echo "Checking images directory..."
if [ -d "storage/app/public/blog/categories" ]; then
    echo "✅ مجلد الصور موجود"
    echo "Images directory exists"
    ls -la storage/app/public/blog/categories/
else
    echo "❌ مجلد الصور غير موجود"
    echo "Images directory does not exist"
    echo "إنشاء مجلد الصور..."
    echo "Creating images directory..."
    mkdir -p storage/app/public/blog/categories
    mkdir -p storage/app/public/blog/posts
    chmod -R 777 storage/app/public/blog/
fi

echo ""
echo "📋 الخطوة 2: إنشاء الصور المفقودة"
echo "Step 2: Creating missing images"

# إنشاء صورة بسيطة للاختبار
echo "إنشاء صورة اختبار..."
echo "Creating test image..."

# إنشاء صورة PNG بسيطة باستخدام ImageMagick أو fallback
if command -v convert &> /dev/null; then
    echo "استخدام ImageMagick لإنشاء الصور..."
    echo "Using ImageMagick to create images..."
    
    # إنشاء صورة بسيطة
    convert -size 300x200 xc:lightblue -pointsize 20 -fill black -gravity center -annotate +0+0 "Blog Image" storage/app/public/blog/categories/test_image.jpg
    
    # إنشاء صور إضافية
    convert -size 300x200 xc:lightgreen -pointsize 20 -fill black -gravity center -annotate +0+0 "Category 1" storage/app/public/blog/categories/category_1.jpg
    convert -size 300x200 xc:lightcoral -pointsize 20 -fill black -gravity center -annotate +0+0 "Category 2" storage/app/public/blog/categories/category_2.jpg
    convert -size 300x200 xc:lightyellow -pointsize 20 -fill black -gravity center -annotate +0+0 "Category 3" storage/app/public/blog/categories/category_3.jpg
    convert -size 300x200 xc:lightpink -pointsize 20 -fill black -gravity center -annotate +0+0 "Category 4" storage/app/public/blog/categories/category_4.jpg
    
    echo "✅ تم إنشاء الصور باستخدام ImageMagick"
    echo "Images created using ImageMagick"
else
    echo "ImageMagick غير متوفر، استخدام حل بديل..."
    echo "ImageMagick not available, using alternative solution..."
    
    # إنشاء ملفات صور وهمية (يمكن استبدالها لاحقاً)
    echo "إنشاء ملفات صور وهمية..."
    echo "Creating dummy image files..."
    
    # إنشاء ملفات فارغة مع أسماء الصور
    touch storage/app/public/blog/categories/test_image.jpg
    touch storage/app/public/blog/categories/category_1.jpg
    touch storage/app/public/blog/categories/category_2.jpg
    touch storage/app/public/blog/categories/category_3.jpg
    touch storage/app/public/blog/categories/category_4.jpg
    
    echo "⚠️  تم إنشاء ملفات صور فارغة (يجب استبدالها بصور حقيقية)"
    echo "Created empty image files (should be replaced with real images)"
fi

echo ""
echo "📋 الخطوة 3: تحديث قاعدة البيانات"
echo "Step 3: Updating database"

echo "تشغيل الـ seeder لإضافة البيانات..."
echo "Running seeder to add data..."

# تشغيل الـ seeder
php artisan db:seed --class=BlogSeeder

echo ""
echo "📋 الخطوة 4: إصلاح الـ symbolic link"
echo "Step 4: Fixing symbolic link"

echo "حذف الـ symbolic link القديم..."
echo "Removing old symbolic link..."
rm -f public/storage
rm -rf public/storage

echo "إنشاء الـ symbolic link جديد..."
echo "Creating new symbolic link..."
php artisan storage:link --force

echo "التحقق من الـ symbolic link..."
echo "Checking symbolic link..."
if [ -L "public/storage" ]; then
    echo "✅ الـ symbolic link تم إنشاؤه بنجاح"
    echo "Symbolic link created successfully"
    ls -la public/storage
else
    echo "❌ فشل في إنشاء الـ symbolic link"
    echo "Failed to create symbolic link"
    echo "محاولة يدوية..."
    echo "Manual attempt..."
    ln -sf ../storage/app/public public/storage
fi

echo ""
echo "📋 الخطوة 5: تحديث APP_URL"
echo "Step 5: Updating APP_URL"

# نسخ احتياطي من ملف .env
cp .env .env.backup.$(date +%Y%m%d_%H%M%S)

# تحديث APP_URL
sed -i 's|APP_URL=.*|APP_URL=https://biker.caesar-agency.com|g' .env

echo "التحقق من APP_URL..."
echo "Checking APP_URL..."
APP_URL=$(grep "APP_URL=" .env | cut -d '=' -f2)
echo "APP_URL الجديد: $APP_URL"
echo "New APP_URL: $APP_URL"

echo ""
echo "📋 الخطوة 6: مسح الكاش"
echo "Step 6: Clearing cache"

php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
php artisan optimize:clear

echo ""
echo "📋 الخطوة 7: إصلاح الصلاحيات"
echo "Step 7: Fixing permissions"

chmod -R 755 storage/
chmod -R 777 storage/app/public/
chmod -R 777 storage/logs/
chmod -R 755 public/
chmod -R 777 public/storage/
chmod -R 755 bootstrap/cache/

echo ""
echo "📋 الخطوة 8: اختبار الصور"
echo "Step 8: Testing images"

if [ -d "storage/app/public/blog/categories" ]; then
    IMAGE_COUNT=$(ls -1 storage/app/public/blog/categories/*.jpg 2>/dev/null | wc -l)
    echo "✅ عدد الصور الموجودة: $IMAGE_COUNT"
    echo "Number of images found: $IMAGE_COUNT"
    
    if [ $IMAGE_COUNT -gt 0 ]; then
        echo "الصور الموجودة:"
        echo "Existing images:"
        ls -la storage/app/public/blog/categories/
        
        # اختبار أول صورة
        TEST_IMAGE=$(ls storage/app/public/blog/categories/*.jpg | head -1 | xargs basename)
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
        sleep 2
        
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://biker.caesar-agency.com/storage/blog/categories/$TEST_IMAGE")
        
        if [ "$HTTP_STATUS" = "200" ]; then
            echo "✅ الصورة متاحة عبر HTTP (Status: $HTTP_STATUS)"
            echo "Image is accessible via HTTP (Status: $HTTP_STATUS)"
        else
            echo "❌ الصورة غير متاحة عبر HTTP (Status: $HTTP_STATUS)"
            echo "Image is not accessible via HTTP (Status: $HTTP_STATUS)"
        fi
    else
        echo "❌ لا توجد صور في المجلد"
        echo "No images found in directory"
    fi
else
    echo "❌ مجلد الصور غير موجود"
    echo "Images directory does not exist"
fi

echo ""
echo "📋 الخطوة 9: إنشاء ملف تعليمات"
echo "Step 9: Creating instructions file"

cat > IMAGE_SETUP_INSTRUCTIONS.md << 'EOF'
# 🖼️ تعليمات إعداد الصور على السيرفر الخارجي

## المشكلة التي تم حلها
كان مجلد الصور `/var/www/biker/storage/app/public/blog/categories/` غير موجود على السيرفر الخارجي.

## الحلول المطبقة
1. ✅ إنشاء مجلدات الصور المفقودة
2. ✅ إنشاء صور اختبار (إذا كان ImageMagick متوفراً)
3. ✅ تشغيل BlogSeeder لإضافة البيانات
4. ✅ إصلاح الـ symbolic link
5. ✅ تحديث APP_URL
6. ✅ مسح جميع أنواع الكاش
7. ✅ إصلاح صلاحيات الملفات

## الخطوات التالية

### إذا كانت الصور لا تزال لا تظهر:
1. **رفع صور حقيقية**: انسخ الصور الحقيقية إلى `/var/www/biker/storage/app/public/blog/categories/`
2. **مسح كاش Cloudflare**: إذا كنت تستخدم Cloudflare
3. **إعادة تشغيل الخدمات**: `systemctl restart nginx php8.1-fpm`

### لرفع صور جديدة:
```bash
# انسخ الصور إلى السيرفر
scp *.jpg user@server:/var/www/biker/storage/app/public/blog/categories/

# أو استخدم SFTP
# أو استخدم لوحة تحكم الملفات في cPanel

# تأكد من الصلاحيات
chmod 644 /var/www/biker/storage/app/public/blog/categories/*.jpg
```

### لاختبار الصور:
```bash
# اختبر صورة عشوائية
curl -I "https://biker.caesar-agency.com/storage/blog/categories/[اسم_الصورة].jpg"

# يجب أن تحصل على HTTP 200 OK
```

## ملاحظات مهمة
- تأكد من أن أسماء الصور في قاعدة البيانات تطابق أسماء الملفات
- استخدم أسماء ملفات بسيطة (بدون مسافات أو أحرف خاصة)
- حجم الصور يجب أن يكون مناسباً (أقل من 2MB)
- نوع الملفات: JPG, PNG, GIF

## الدعم
إذا استمرت المشكلة، تحقق من:
1. إعدادات Nginx/Apache
2. صلاحيات الملفات
3. Cloudflare cache
4. SSL certificate
EOF

echo "✅ تم إنشاء ملف التعليمات: IMAGE_SETUP_INSTRUCTIONS.md"
echo "Instructions file created: IMAGE_SETUP_INSTRUCTIONS.md"

echo ""
echo "📋 الخطوة 10: تقرير نهائي"
echo "Step 10: Final report"

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

echo "1. رفع صور حقيقية إلى مجلد الصور"
echo "1. Upload real images to images directory"

echo "2. التأكد من أن أسماء الصور في قاعدة البيانات تطابق أسماء الملفات"
echo "2. Ensure image names in database match file names"

echo "3. مسح كاش Cloudflare إذا كان مستخدماً"
echo "3. Clear Cloudflare cache if used"

echo "4. إعادة تشغيل الخدمات"
echo "4. Restart services"

echo ""
echo "✅ تم الانتهاء من إنشاء الصور المفقودة!"
echo "Missing images creation completed!"

echo ""
echo "🎉 انتهى السكريبت!"
echo "Script finished!"
