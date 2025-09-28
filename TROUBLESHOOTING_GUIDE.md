# 🔍 دليل استكشاف أخطاء الصور على السيرفر الخارجي

## المشكلة الأساسية
الصور تعطي 404 على `https://biker.caesar-agency.com/storage/blog/categories/[image].jpg`

## الحلول المتدرجة

### 1️⃣ الحل الأساسي (جرب هذا أولاً)
```bash
cd /var/www/biker
./complete_image_fix.sh
```

### 2️⃣ إذا فشل الحل الأساسي - فحص الـ Web Server

#### للـ Nginx:
```bash
# تحقق من إعدادات Nginx
sudo nano /etc/nginx/sites-available/biker.caesar-agency.com

# تأكد من وجود هذا السطر:
location /storage {
    alias /var/www/biker/public/storage;
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# إعادة تحميل Nginx
sudo systemctl reload nginx
```

#### للـ Apache:
```bash
# تحقق من إعدادات Apache
sudo nano /etc/apache2/sites-available/biker.caesar-agency.com.conf

# تأكد من وجود هذا السطر:
Alias /storage /var/www/biker/public/storage
<Directory /var/www/biker/public/storage>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

# إعادة تحميل Apache
sudo systemctl reload apache2
```

### 3️⃣ فحص Cloudflare (إذا كان مستخدماً)

#### مسح كاش Cloudflare:
1. ادخل إلى لوحة تحكم Cloudflare
2. اذهب إلى "Caching" → "Configuration"
3. اضغط "Purge Everything"

#### أو عبر API:
```bash
# احصل على API token من Cloudflare
curl -X POST "https://api.cloudflare.com/client/v4/zones/ZONE_ID/purge_cache" \
     -H "Authorization: Bearer YOUR_API_TOKEN" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'
```

### 4️⃣ فحص SSL Certificate
```bash
# تحقق من صحة SSL
openssl s_client -connect biker.caesar-agency.com:443 -servername biker.caesar-agency.com

# أو
curl -I https://biker.caesar-agency.com/storage/test.txt
```

### 5️⃣ فحص صلاحيات الملفات المتقدم
```bash
cd /var/www/biker

# إصلاح صلاحيات شاملة
sudo chown -R www-data:www-data .
sudo chmod -R 755 .
sudo chmod -R 777 storage/
sudo chmod -R 777 public/storage/
sudo chmod -R 777 bootstrap/cache/

# إصلاح SELinux (إذا كان مفعلاً)
sudo setsebool -P httpd_can_network_connect 1
sudo setsebool -P httpd_read_user_content 1
sudo restorecon -R /var/www/biker/
```

### 6️⃣ إنشاء symbolic link يدوياً
```bash
cd /var/www/biker

# حذف الـ symbolic link القديم
rm -f public/storage
rm -rf public/storage

# إنشاء الـ symbolic link يدوياً
ln -sf /var/www/biker/storage/app/public /var/www/biker/public/storage

# التحقق
ls -la public/storage
```

### 7️⃣ فحص Laravel Configuration
```bash
cd /var/www/biker

# تحقق من ملف .env
cat .env | grep APP_URL

# تحقق من ملف config/filesystems.php
php artisan config:show filesystems.disks.local

# إعادة إنشاء symbolic link
php artisan storage:link --force
```

### 8️⃣ اختبار مباشر للملفات
```bash
cd /var/www/biker

# اختبار وجود الصور
ls -la storage/app/public/blog/categories/

# اختبار الـ symbolic link
ls -la public/storage/blog/categories/

# اختبار HTTP مباشر
curl -I "https://biker.caesar-agency.com/storage/blog/categories/AebD0QxZg360OBzr3E0mWjkCXi2bTBaT2C3i906v.jpg"

# اختبار مع headers مختلفة
curl -I -H "User-Agent: Mozilla/5.0" "https://biker.caesar-agency.com/storage/blog/categories/AebD0QxZg360OBzr3E0mWjkCXi2bTBaT2C3i906v.jpg"
```

### 9️⃣ فحص Logs
```bash
# Laravel logs
tail -f storage/logs/laravel.log

# Nginx logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log

# Apache logs (إذا كان مستخدماً)
sudo tail -f /var/log/apache2/error.log
sudo tail -f /var/log/apache2/access.log
```

### 🔟 الحل النهائي - إعادة إنشاء الصور
إذا فشلت جميع الحلول السابقة:

```bash
cd /var/www/biker

# حذف الصور القديمة
rm -rf storage/app/public/blog/

# إعادة إنشاء المجلدات
mkdir -p storage/app/public/blog/categories
mkdir -p storage/app/public/blog/posts

# إعادة تشغيل الـ seeder
php artisan db:seed --class=BlogSeeder

# إعادة إنشاء الـ symbolic link
php artisan storage:link --force

# مسح الكاش
php artisan optimize:clear
```

## تشخيص المشكلة

### إذا كانت الصور تظهر في المتصفح المحلي ولكن لا تظهر على السيرفر الخارجي:
- المشكلة في إعدادات الـ web server
- أو في Cloudflare cache
- أو في SSL configuration

### إذا كانت الصور لا تظهر حتى محلياً:
- المشكلة في الـ symbolic link
- أو في صلاحيات الملفات
- أو في Laravel configuration

### إذا كانت بعض الصور تظهر وبعضها لا:
- المشكلة في أسماء الملفات (مسافات، أحرف خاصة)
- أو في حجم الملفات
- أو في نوع الملفات

## نصائح إضافية

1. **استخدم أسماء ملفات بسيطة**: تجنب المسافات والأحرف الخاصة
2. **تحقق من حجم الملفات**: تأكد من أن الملفات ليست كبيرة جداً
3. **استخدم HTTPS**: تأكد من أن SSL certificate صحيح
4. **امسح الكاش**: استخدم `php artisan optimize:clear` بعد كل تغيير
5. **تحقق من الـ logs**: راقب logs الأخطاء باستمرار

## في حالة الطوارئ

إذا لم تعمل أي من الحلول السابقة، استخدم هذا الحل المؤقت:

```bash
# نسخ الصور مباشرة إلى مجلد public
cp -r storage/app/public/blog public/blog_images

# تحديث الروابط في قاعدة البيانات لاستخدام المسار الجديد
# أو استخدام CDN خارجي للصور
```

## الدعم الفني

إذا استمرت المشكلة، قدم هذه المعلومات:

1. نوع الـ web server (Nginx/Apache)
2. إصدار PHP
3. إصدار Laravel
4. هل تستخدم Cloudflare؟
5. هل تستخدم SSL؟
6. محتوى ملف `.env`
7. محتوى logs الأخطاء
