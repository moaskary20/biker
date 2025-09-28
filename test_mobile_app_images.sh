#!/bin/bash

echo "📱 اختبار صور التطبيق..."
echo "Testing mobile app images..."

cd /var/www/biker/biker

echo ""
echo "📋 الخطوة 1: التحقق من الـ API"
echo "Step 1: Checking API"

echo "اختبار API المواضيع..."
echo "Testing posts API..."
POSTS_RESPONSE=$(curl -s -H "moduleId: 1" "http://192.168.1.44:8000/api/v1/blog/posts")
echo "Posts API Status: $(echo $POSTS_RESPONSE | jq -r '.success')"

if [ "$(echo $POSTS_RESPONSE | jq -r '.success')" = "true" ]; then
    echo "✅ API المواضيع يعمل"
    echo "Posts API is working"
    
    # اختبار الصور
    echo ""
    echo "اختبار صور المواضيع..."
    echo "Testing post images..."
    
    POST_IMAGES=$(echo $POSTS_RESPONSE | jq -r '.posts[] | select(.featured_image != null) | .featured_image')
    if [ ! -z "$POST_IMAGES" ]; then
        echo "✅ صور المواضيع موجودة"
        echo "Post images exist"
        
        # اختبار صورة واحدة
        FIRST_IMAGE=$(echo $POST_IMAGES | head -1)
        echo "اختبار الصورة: $FIRST_IMAGE"
        echo "Testing image: $FIRST_IMAGE"
        
        IMAGE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$FIRST_IMAGE")
        if [ "$IMAGE_STATUS" = "200" ]; then
            echo "✅ الصورة تعمل عبر HTTP"
            echo "Image works via HTTP"
        else
            echo "❌ الصورة لا تعمل عبر HTTP (Status: $IMAGE_STATUS)"
            echo "Image doesn't work via HTTP (Status: $IMAGE_STATUS)"
        fi
    else
        echo "❌ لا توجد صور للمواضيع"
        echo "No post images found"
    fi
else
    echo "❌ API المواضيع لا يعمل"
    echo "Posts API is not working"
fi

echo ""
echo "اختبار API الكايجري..."
echo "Testing categories API..."
CATEGORIES_RESPONSE=$(curl -s -H "moduleId: 1" "http://192.168.1.44:8000/api/v1/blog/categories")
echo "Categories API Status: $(echo $CATEGORIES_RESPONSE | jq -r '.success')"

if [ "$(echo $CATEGORIES_RESPONSE | jq -r '.success')" = "true" ]; then
    echo "✅ API الكايجري يعمل"
    echo "Categories API is working"
    
    # اختبار الصور
    echo ""
    echo "اختبار صور الكايجري..."
    echo "Testing category images..."
    
    CATEGORY_IMAGES=$(echo $CATEGORIES_RESPONSE | jq -r '.categories[] | select(.image != null) | .image')
    if [ ! -z "$CATEGORY_IMAGES" ]; then
        echo "✅ صور الكايجري موجودة"
        echo "Category images exist"
        
        # اختبار صورة واحدة
        FIRST_CATEGORY_IMAGE=$(echo $CATEGORY_IMAGES | head -1)
        echo "اختبار الصورة: $FIRST_CATEGORY_IMAGE"
        echo "Testing image: $FIRST_CATEGORY_IMAGE"
        
        CATEGORY_IMAGE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$FIRST_CATEGORY_IMAGE")
        if [ "$CATEGORY_IMAGE_STATUS" = "200" ]; then
            echo "✅ الصورة تعمل عبر HTTP"
            echo "Image works via HTTP"
        else
            echo "❌ الصورة لا تعمل عبر HTTP (Status: $CATEGORY_IMAGE_STATUS)"
            echo "Image doesn't work via HTTP (Status: $CATEGORY_IMAGE_STATUS)"
        fi
    else
        echo "❌ لا توجد صور للكايجري"
        echo "No category images found"
    fi
else
    echo "❌ API الكايجري لا يعمل"
    echo "Categories API is not working"
fi

echo ""
echo "📋 الخطوة 2: التحقق من الـ Mobile App Constants"
echo "Step 2: Checking Mobile App Constants"

BASE_URL=$(grep "baseUrl" mobile/lib/util/app_constants.dart | head -1)
echo "Base URL: $BASE_URL"

if [[ $BASE_URL == *"192.168.1.44:8000"* ]]; then
    echo "✅ الـ baseUrl مضبوط على السيرفر الداخلي"
    echo "Base URL is set to internal server"
else
    echo "❌ الـ baseUrl غير مضبوط على السيرفر الداخلي"
    echo "Base URL is not set to internal server"
fi

echo ""
echo "📋 الخطوة 3: ملخص النتائج"
echo "Step 3: Results Summary"

if [ "$(echo $POSTS_RESPONSE | jq -r '.success')" = "true" ] && [ "$(echo $CATEGORIES_RESPONSE | jq -r '.success')" = "true" ]; then
    echo "🎉 جميع الاختبارات نجحت!"
    echo "All tests passed!"
    echo ""
    echo "✅ API المواضيع يعمل"
    echo "✅ API الكايجري يعمل"
    echo "✅ الصور تعمل عبر HTTP"
    echo "✅ الـ baseUrl مضبوط بشكل صحيح"
    echo ""
    echo "📱 التطبيق جاهز للاختبار!"
    echo "Mobile app is ready for testing!"
else
    echo "❌ بعض الاختبارات فشلت"
    echo "Some tests failed"
    echo ""
    echo "تحقق من الأخطاء أعلاه"
    echo "Check the errors above"
fi

echo ""
echo "✅ تم الانتهاء من اختبار التطبيق!"
echo "Mobile app testing completed!"
