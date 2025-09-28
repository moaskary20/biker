#!/bin/bash

echo "🔍 اختبار نهائي للصور..."
echo "Final image test..."

cd /var/www/biker/biker

echo ""
echo "📋 التحقق من الإعدادات:"
echo "Checking settings:"

echo "APP_URL: $(grep APP_URL .env)"
echo "Symbolic link: $(ls -la public/storage 2>/dev/null | head -1)"
echo "Images count: $(ls storage/app/public/blog/categories/*.jpg 2>/dev/null | wc -l)"

echo ""
echo "📋 اختبار الصور:"
echo "Testing images:"

# اختبار صورة عشوائية
TEST_IMAGE="Mf2zbWXAUlqeyUFvmeJkOTZzr3K4YLPrlFyXnwQZ.jpg"
echo "Testing image: $TEST_IMAGE"

# اختبار HTTP مباشر
echo "1. Direct HTTP access..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://192.168.1.44:8000/storage/blog/categories/$TEST_IMAGE")
echo "   Status: $HTTP_STATUS"

# اختبار عبر asset helper
echo "2. Asset helper..."
ASSET_URL=$(php artisan tinker --execute="echo asset('storage/blog/categories/$TEST_IMAGE');" 2>/dev/null)
echo "   URL: $ASSET_URL"

if [ ! -z "$ASSET_URL" ]; then
    ASSET_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$ASSET_URL")
    echo "   Status: $ASSET_STATUS"
fi

# اختبار الـ Blade template
echo "3. Blade template test..."
BLADE_URL=$(php artisan tinker --execute="
\$category = new stdClass();
\$category->image = 'blog/categories/$TEST_IMAGE';
echo asset('storage/' . \$category->image);
" 2>/dev/null)
echo "   URL: $BLADE_URL"

if [ ! -z "$BLADE_URL" ]; then
    BLADE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BLADE_URL")
    echo "   Status: $BLADE_STATUS"
fi

echo ""
echo "📋 النتيجة:"
echo "Result:"

if [ "$HTTP_STATUS" = "200" ] && [ "$ASSET_STATUS" = "200" ] && [ "$BLADE_STATUS" = "200" ]; then
    echo "✅ جميع الاختبارات نجحت!"
    echo "All tests passed!"
    echo ""
    echo "🎉 الصور تعمل بشكل صحيح!"
    echo "Images are working correctly!"
    echo ""
    echo "📋 إذا كانت الصور لا تظهر في الـ admin panel:"
    echo "If images don't show in admin panel:"
    echo "1. تأكد من تسجيل الدخول في الـ admin panel"
    echo "2. امسح كاش المتصفح (Ctrl+F5)"
    echo "3. تحقق من console المتصفح للأخطاء"
    echo "4. تأكد من أن الـ JavaScript يعمل بشكل صحيح"
else
    echo "❌ بعض الاختبارات فشلت"
    echo "Some tests failed"
    echo ""
    echo "HTTP Status: $HTTP_STATUS"
    echo "Asset Status: $ASSET_STATUS"
    echo "Blade Status: $BLADE_STATUS"
fi

echo ""
echo "✅ تم الانتهاء من الاختبار!"
echo "Test completed!"

