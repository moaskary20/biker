<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use App\CentralLogics\Helpers;
use Illuminate\Support\Facades\DB;

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

    protected $appends = ['image_full_url'];

    // العلاقة مع المقالات
    public function posts()
    {
        return $this->hasMany(BlogPost::class, 'category_id');
    }

    // العلاقة مع Storage
    public function storage()
    {
        return $this->morphMany(Storage::class, 'data');
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

        static::saved(function ($model) {
            if($model->isDirty('image')){
                $value = Helpers::getDisk();

                DB::table('storages')->updateOrInsert([
                    'data_type' => get_class($model),
                    'data_id' => $model->id,
                    'key' => 'image',
                ], [
                    'value' => $value,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
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

    // الحصول على رابط الصورة للعرض في الـ admin (نفس طريقة المنتجات)
    public function getImageFullUrlAttribute()
    {
        $value = $this->getRawOriginal('image');
        if ($value) {
            if (count($this->storage) > 0) {
                foreach ($this->storage as $storage) {
                    if ($storage['key'] == 'image') {
                        return Helpers::get_full_url('blog/categories', $value, $storage['value']);
                    }
                }
            }
            return Helpers::get_full_url('blog/categories', $value, 'public');
        }
        return null;
    }

    // للحفاظ على التوافق مع الكود القديم
    public function getImageUrlAttribute()
    {
        return $this->image_full_url;
    }
}