#!/bin/bash

echo "🔍 اختبار الصور في الـ admin panel..."
echo "Testing images in admin panel..."

cd /var/www/biker

echo ""
echo "📋 الخطوة 1: التحقق من APP_URL"
echo "Step 1: Checking APP_URL"
echo "APP_URL: $(grep APP_URL .env)"

echo ""
echo "📋 الخطوة 2: التحقق من الـ symbolic link"
echo "Step 2: Checking symbolic link"
if [ -L "public/storage" ]; then
    echo "✅ الـ symbolic link موجود"
    echo "Symbolic link exists"
    ls -la public/storage
else
    echo "❌ الـ symbolic link غير موجود"
    echo "Symbolic link does not exist"
fi

echo ""
echo "📋 الخطوة 3: التحقق من الصور"
echo "Step 3: Checking images"
if [ -d "storage/app/public/blog/categories" ]; then
    echo "✅ مجلد الصور موجود"
    echo "Images directory exists"
    echo "عدد الصور: $(ls storage/app/public/blog/categories/*.jpg 2>/dev/null | wc -l)"
    echo "Number of images: $(ls storage/app/public/blog/categories/*.jpg 2>/dev/null | wc -l)"
    
    # اختبار صورة عشوائية
    TEST_IMAGE=$(ls storage/app/public/blog/categories/*.jpg 2>/dev/null | head -1 | xargs basename)
    if [ ! -z "$TEST_IMAGE" ]; then
        echo "اختبار الصورة: $TEST_IMAGE"
        echo "Testing image: $TEST_IMAGE"
        
        # اختبار عبر الـ symbolic link
        if [ -f "public/storage/blog/categories/$TEST_IMAGE" ]; then
            echo "✅ الصورة متاحة عبر الـ symbolic link"
            echo "Image is accessible via symbolic link"
        else
            echo "❌ الصورة غير متاحة عبر الـ symbolic link"
            echo "Image is not accessible via symbolic link"
        fi
        
        # اختبار HTTP
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://192.168.1.44:8000/storage/blog/categories/$TEST_IMAGE")
        echo "HTTP Status: $HTTP_STATUS"
        
        if [ "$HTTP_STATUS" = "200" ]; then
            echo "✅ الصورة متاحة عبر HTTP"
            echo "Image is accessible via HTTP"
        else
            echo "❌ الصورة غير متاحة عبر HTTP"
            echo "Image is not accessible via HTTP"
        fi
    fi
else
    echo "❌ مجلد الصور غير موجود"
    echo "Images directory does not exist"
fi

echo ""
echo "📋 الخطوة 4: اختبار الـ admin panel"
echo "Step 4: Testing admin panel"

# اختبار صفحة الـ categories
ADMIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://192.168.1.44:8000/admin/blog/categories")
echo "Admin Categories Page Status: $ADMIN_STATUS"

if [ "$ADMIN_STATUS" = "200" ]; then
    echo "✅ صفحة الـ admin panel تعمل"
    echo "Admin panel page is working"
else
    echo "❌ صفحة الـ admin panel لا تعمل"
    echo "Admin panel page is not working"
fi

echo ""
echo "✅ تم الانتهاء من الاختبار!"
echo "Testing completed!"

