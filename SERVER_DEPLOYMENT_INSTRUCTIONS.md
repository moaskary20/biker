# تعليمات نشر التحديثات على السيرفر الخارجي

## المشكلة الحالية
الصور لا تظهر على السيرفر الخارجي `https://biker.caesar-agency.com` لأن:

1. `APP_URL` في ملف `.env` على السيرفر الخارجي لا يزال مضبوط على `http://192.168.1.44:8000`
2. قد تحتاج إلى إعادة إنشاء الـ symbolic link للـ storage
3. قد تحتاج إلى مسح الكاش

## الخطوات المطلوبة على السيرفر الخارجي:

### 1. تحديث APP_URL
```bash
# على السيرفر الخارجي، قم بتحديث ملف .env
sed -i 's|APP_URL=.*|APP_URL=https://biker.caesar-agency.com|g' .env
```

### 2. إعادة إنشاء Storage Link
```bash
# احذف الـ symbolic link القديم
rm -f public/storage

# أنشئ الـ symbolic link جديد
php artisan storage:link
```

### 3. مسح الكاش
```bash
php artisan config:clear
php artisan cache:clear
php artisan view:clear
php artisan route:clear
```

### 4. التحقق من الصلاحيات
```bash
# تأكد من أن مجلد storage له الصلاحيات الصحيحة
chmod -R 755 storage/
chown -R www-data:www-data storage/
```

### 5. اختبار الصور
بعد تنفيذ الخطوات أعلاه، اختبر الصور:
```bash
curl -I "https://biker.caesar-agency.com/storage/blog/categories/gz105vKfhfufFz08eSYjEk09CEtjSJShwSxciyUK.jpg"
```

يجب أن تحصل على `HTTP/1.1 200 OK` بدلاً من `404`.

## ملاحظات مهمة:

1. **تأكد من نسخ الصور**: تأكد من أن جميع الصور في `storage/app/public/blog/` موجودة على السيرفر الخارجي
2. **الصلاحيات**: تأكد من أن الـ web server يمكنه قراءة ملفات الصور
3. **Cloudflare**: إذا كنت تستخدم Cloudflare، قد تحتاج إلى مسح الكاش هناك أيضاً

## التحقق من النجاح:
بعد تنفيذ جميع الخطوات، يجب أن تظهر الصور في:
- صفحة إدارة المدونة: `https://biker.caesar-agency.com/admin/blog/categories`
- تطبيق الموبايل: في قسم المدونة
