<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class BlogCategory extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'slug',
        'description',
        'image',
        'meta_title',
        'meta_description',
        'is_active',
        'sort_order'
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'sort_order' => 'integer'
    ];

    // العلاقة مع المقالات
    public function posts()
    {
        return $this->hasMany(BlogPost::class, 'category_id');
    }

    // إنشاء slug تلقائياً
    protected static function boot()
    {
        parent::boot();
        
        static::creating(function ($category) {
            if (empty($category->slug)) {
                $category->slug = Str::slug($category->name);
            }
        });
        
        static::updating(function ($category) {
            if ($category->isDirty('name') && empty($category->slug)) {
                $category->slug = Str::slug($category->name);
            }
        });
    }

    // Scope للحصول على الأقسام النشطة فقط
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    // الحصول على عدد المقالات في القسم
    public function getPostsCountAttribute()
    {
        return $this->posts()->count();
    }

    // الحصول على رابط الصورة للـ API
    public function getImageAttribute($value)
    {
        if ($value) {
            if (str_starts_with($value, 'http')) {
                return $value;
            }
            return asset('storage/' . $value);
        }
        return null;
    }

    // الحصول على رابط الصورة للعرض في الـ admin
    public function getImageUrlAttribute()
    {
        $value = $this->getRawOriginal('image');
        if ($value) {
            if (str_starts_with($value, 'http')) {
                return $value;
            }
            
            // التحقق من وجود الملف
            $fullPath = storage_path('app/public/' . $value);
            if (file_exists($fullPath)) {
                // إضافة timestamp للـ cache busting
                $timestamp = filemtime($fullPath);
                return url('blog-image/' . $value . '?v=' . $timestamp);
            }
        }
        return null;
    }
}