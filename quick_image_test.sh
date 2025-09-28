#!/bin/bash

echo "🔍 اختبار سريع للصور..."
echo "Quick image test..."

cd /var/www/biker

echo ""
echo "📋 التحقق من الإعدادات:"
echo "Checking settings:"

echo "APP_URL: $(grep APP_URL .env)"
echo "Symbolic link: $(ls -la public/storage 2>/dev/null | head -1)"
echo "Images count: $(ls storage/app/public/blog/categories/*.jpg 2>/dev/null | wc -l)"

echo ""
echo "📋 اختبار صورة عشوائية:"
echo "Testing random image:"

TEST_IMAGE=$(ls storage/app/public/blog/categories/*.jpg 2>/dev/null | head -1 | xargs basename)
if [ ! -z "$TEST_IMAGE" ]; then
    echo "Image: $TEST_IMAGE"
    
    # اختبار HTTP مباشر
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://192.168.1.44:8000/storage/blog/categories/$TEST_IMAGE")
    echo "Direct HTTP Status: $HTTP_STATUS"
    
    # اختبار عبر asset helper
    ASSET_URL=$(php artisan tinker --execute="echo asset('storage/blog/categories/$TEST_IMAGE');" 2>/dev/null)
    echo "Asset URL: $ASSET_URL"
    
    if [ ! -z "$ASSET_URL" ]; then
        ASSET_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$ASSET_URL")
        echo "Asset HTTP Status: $ASSET_STATUS"
    fi
    
    if [ "$HTTP_STATUS" = "200" ]; then
        echo "✅ الصور تعمل!"
        echo "Images are working!"
    else
        echo "❌ الصور لا تعمل!"
        echo "Images are not working!"
    fi
else
    echo "❌ لا توجد صور للاختبار"
    echo "No images to test"
fi

echo ""
echo "✅ تم الانتهاء من الاختبار!"
echo "Test completed!"

