<?php

namespace App\Helpers;

use Illuminate\Support\Facades\Storage;

class ImageHelper
{
    /**
     * حذف صورة من التخزين
     * 
     * @param string $imagePath المسار المخزن في قاعدة البيانات
     * @param string $storagePath المسار في التخزين (مثل 'blog/posts' أو 'blog/categories')
     * @return bool
     */
    public static function deleteImage($imagePath, $storagePath)
    {
        if (empty($imagePath)) {
            return false;
        }

        // إذا كان الرابط كاملاً، استخرج اسم الملف فقط
        if (str_starts_with($imagePath, 'http')) {
            $imagePath = basename(parse_url($imagePath, PHP_URL_PATH));
        }

        // إذا كان المسار لا يحتوي على المجلد، أضفه
        if (!str_contains($imagePath, '/')) {
            $imagePath = $storagePath . '/' . $imagePath;
        }

        try {
            // محاولة الحذف باستخدام Storage
            $result = Storage::disk('public')->delete($imagePath);
            
            if ($result) {
                \Log::info('Successfully deleted image: ' . $imagePath);
                return true;
            } else {
                // إذا فشل الحذف، سجل في ملف للتنظيف لاحقاً
                \Log::warning('Failed to delete image (will be cleaned up later): ' . $imagePath);
                return false;
            }
        } catch (\Exception $e) {
            // في حالة فشل الحذف، لا نريد إيقاف العملية
            \Log::warning('Failed to delete image: ' . $imagePath . ' - ' . $e->getMessage());
            return false;
        }
    }

    /**
     * رفع صورة جديدة
     * 
     * @param \Illuminate\Http\UploadedFile $file الملف المرفوع
     * @param string $storagePath المسار في التخزين
     * @return string|false
     */
    public static function uploadImage($file, $storagePath)
    {
        if (!$file) {
            return false;
        }

        // التحقق من صحة الملف
        if (method_exists($file, 'isValid') && !$file->isValid()) {
            return false;
        }

        try {
            // محاولة الرفع باستخدام Storage
            $result = $file->store($storagePath, 'public');
            
            if ($result) {
                return $result;
            }
            
            // إذا فشل، جرب الرفع المباشر
            $filename = time() . '-' . uniqid() . '.' . $file->getClientOriginalExtension();
            $fullPath = storage_path('app/public/' . $storagePath . '/' . $filename);
            
            // إنشاء المجلد إذا لم يكن موجوداً
            $dir = dirname($fullPath);
            if (!is_dir($dir)) {
                mkdir($dir, 0755, true);
            }
            
            // نسخ الملف
            if (copy($file->getPathname(), $fullPath)) {
                return $storagePath . '/' . $filename;
            }
            
            return false;
        } catch (\Exception $e) {
            \Log::error('Failed to upload image: ' . $e->getMessage());
            return false;
        }
    }
}
