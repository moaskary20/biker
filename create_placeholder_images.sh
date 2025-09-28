#!/bin/bash

echo "🎨 إنشاء صور وهمية للكايجري والمواضيع..."
echo "Creating placeholder images for categories and posts..."

cd /var/www/biker/biker

echo ""
echo "📋 الخطوة 1: إنشاء مجلدات الصور"
echo "Step 1: Creating image directories"

mkdir -p storage/app/public/blog/categories
mkdir -p storage/app/public/blog/posts

echo ""
echo "📋 الخطوة 2: إنشاء صور الكايجري"
echo "Step 2: Creating category images"

# إنشاء صور الكايجري باستخدام ImageMagick
if command -v convert &> /dev/null; then
    echo "إنشاء صورة Technology..."
    convert -size 300x200 xc:lightblue -pointsize 20 -fill black -gravity center -annotate +0+0 "Technology\nCategory" storage/app/public/blog/categories/technology.jpg 2>/dev/null || echo "فشل في إنشاء صورة Technology"
    
    echo "إنشاء صورة Programming..."
    convert -size 300x200 xc:lightgreen -pointsize 20 -fill black -gravity center -annotate +0+0 "Programming\nCategory" storage/app/public/blog/categories/programming.jpg 2>/dev/null || echo "فشل في إنشاء صورة Programming"
    
    echo "إنشاء صورة Web Development..."
    convert -size 300x200 xc:lightcoral -pointsize 20 -fill black -gravity center -annotate +0+0 "Web Development\nCategory" storage/app/public/blog/categories/web-development.jpg 2>/dev/null || echo "فشل في إنشاء صورة Web Development"
    
    echo "إنشاء صورة News..."
    convert -size 300x200 xc:lightyellow -pointsize 20 -fill black -gravity center -annotate +0+0 "News\nCategory" storage/app/public/blog/categories/news.jpg 2>/dev/null || echo "فشل في إنشاء صورة News"
    
    echo ""
    echo "📋 الخطوة 3: إنشاء صور المواضيع"
    echo "Step 3: Creating post images"
    
    echo "إنشاء صورة Laravel 10..."
    convert -size 400x250 xc:lightsteelblue -pointsize 18 -fill black -gravity center -annotate +0+0 "Laravel 10\nNew Features" storage/app/public/blog/posts/laravel-10.jpg 2>/dev/null || echo "فشل في إنشاء صورة Laravel 10"
    
    echo "إنشاء صورة PHP Best Practices..."
    convert -size 400x250 xc:lightpink -pointsize 18 -fill black -gravity center -annotate +0+0 "PHP Best\nPractices" storage/app/public/blog/posts/php-best-practices.jpg 2>/dev/null || echo "فشل في إنشاء صورة PHP Best Practices"
    
    echo "إنشاء صورة Vue.js..."
    convert -size 400x250 xc:lightseagreen -pointsize 18 -fill black -gravity center -annotate +0+0 "Vue.js\nModern UI" storage/app/public/blog/posts/vuejs-ui.jpg 2>/dev/null || echo "فشل في إنشاء صورة Vue.js"
    
    echo "إنشاء صورة AI News..."
    convert -size 400x250 xc:lightgoldenrodyellow -pointsize 18 -fill black -gravity center -annotate +0+0 "AI News\nLatest Updates" storage/app/public/blog/posts/ai-news.jpg 2>/dev/null || echo "فشل في إنشاء صورة AI News"
    
else
    echo "❌ ImageMagick غير مثبت. إنشاء صور بسيطة..."
    echo "ImageMagick not installed. Creating simple images..."
    
    # إنشاء صور بسيطة باستخدام echo
    echo "إنشاء صور بسيطة للكايجري..."
    echo "Technology Category" > storage/app/public/blog/categories/technology.jpg
    echo "Programming Category" > storage/app/public/blog/categories/programming.jpg
    echo "Web Development Category" > storage/app/public/blog/categories/web-development.jpg
    echo "News Category" > storage/app/public/blog/categories/news.jpg
    
    echo "إنشاء صور بسيطة للمواضيع..."
    echo "Laravel 10 Post" > storage/app/public/blog/posts/laravel-10.jpg
    echo "PHP Best Practices Post" > storage/app/public/blog/posts/php-best-practices.jpg
    echo "Vue.js UI Post" > storage/app/public/blog/posts/vuejs-ui.jpg
    echo "AI News Post" > storage/app/public/blog/posts/ai-news.jpg
fi

echo ""
echo "📋 الخطوة 4: إصلاح الصلاحيات"
echo "Step 4: Fixing permissions"

chmod -R 777 storage/app/public/blog/ 2>/dev/null || echo "لا يمكن تغيير الصلاحيات"

echo ""
echo "📋 الخطوة 5: التحقق من الصور"
echo "Step 5: Checking images"

echo "صور الكايجري:"
echo "Category images:"
ls -la storage/app/public/blog/categories/ 2>/dev/null || echo "لا توجد صور للكايجري"

echo ""
echo "صور المواضيع:"
echo "Post images:"
ls -la storage/app/public/blog/posts/ 2>/dev/null || echo "لا توجد صور للمواضيع"

echo ""
echo "✅ تم الانتهاء من إنشاء الصور الوهمية!"
echo "Placeholder images creation completed!"
