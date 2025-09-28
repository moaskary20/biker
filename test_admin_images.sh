#!/bin/bash

echo "🔍 اختبار الصور في الـ admin panel..."
echo "Testing images in admin panel..."

cd /var/www/biker

echo ""
echo "📋 الخطوة 1: التحقق من الإعدادات"
echo "Step 1: Checking settings"

echo "APP_URL: $(grep APP_URL .env)"
echo "Symbolic link: $(ls -la public/storage 2>/dev/null | head -1)"

echo ""
echo "📋 الخطوة 2: اختبار الصور"
echo "Step 2: Testing images"

# اختبار صورة عشوائية
TEST_IMAGE="Mf2zbWXAUlqeyUFvmeJkOTZzr3K4YLPrlFyXnwQZ.jpg"
echo "Testing image: $TEST_IMAGE"

# اختبار HTTP مباشر
echo "Testing direct HTTP access..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://192.168.1.44:8000/storage/blog/categories/$TEST_IMAGE")
echo "Direct HTTP Status: $HTTP_STATUS"

# اختبار عبر asset helper
echo "Testing asset helper..."
ASSET_URL=$(php artisan tinker --execute="echo asset('storage/blog/categories/$TEST_IMAGE');" 2>/dev/null)
echo "Asset URL: $ASSET_URL"

if [ ! -z "$ASSET_URL" ]; then
    ASSET_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$ASSET_URL")
    echo "Asset HTTP Status: $ASSET_STATUS"
fi

echo ""
echo "📋 الخطوة 3: اختبار الـ admin panel"
echo "Step 3: Testing admin panel"

# اختبار صفحة الـ categories
echo "Testing admin categories page..."
ADMIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://192.168.1.44:8000/admin/blog/categories")
echo "Admin Categories Page Status: $ADMIN_STATUS"

if [ "$ADMIN_STATUS" = "200" ]; then
    echo "✅ صفحة الـ admin panel تعمل"
    echo "Admin panel page is working"
elif [ "$ADMIN_STATUS" = "302" ]; then
    echo "⚠️  صفحة الـ admin panel تعيد توجيه (قد تحتاج تسجيل دخول)"
    echo "Admin panel page redirects (may need login)"
else
    echo "❌ صفحة الـ admin panel لا تعمل"
    echo "Admin panel page is not working"
fi

echo ""
echo "📋 الخطوة 4: اختبار الصور في الـ Blade templates"
echo "Step 4: Testing images in Blade templates"

# اختبار الـ Blade template
echo "Testing Blade template image generation..."
BLADE_TEST=$(php artisan tinker --execute="
\$category = new stdClass();
\$category->image = 'blog/categories/$TEST_IMAGE';
echo asset('storage/' . \$category->image);
" 2>/dev/null)
echo "Blade template URL: $BLADE_TEST"

if [ ! -z "$BLADE_TEST" ]; then
    BLADE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BLADE_TEST")
    echo "Blade template HTTP Status: $BLADE_STATUS"
fi

echo ""
if [ "$HTTP_STATUS" = "200" ] && [ "$ASSET_STATUS" = "200" ]; then
    echo "✅ الصور تعمل بشكل صحيح!"
    echo "Images are working correctly!"
    echo ""
    echo "📋 إذا كانت الصور لا تظهر في الـ admin panel:"
    echo "If images don't show in admin panel:"
    echo "1. تأكد من تسجيل الدخول في الـ admin panel"
    echo "2. امسح كاش المتصفح (Ctrl+F5)"
    echo "3. تحقق من console المتصفح للأخطاء"
else
    echo "❌ هناك مشكلة في الصور"
    echo "There's an issue with images"
fi

echo ""
echo "✅ تم الانتهاء من الاختبار!"
echo "Test completed!"

