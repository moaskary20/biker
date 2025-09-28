<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;
use App\CentralLogics\Helpers;
use Illuminate\Support\Facades\DB;

class BlogPost extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'slug',
        'excerpt',
        'content',
        'featured_image',
        'category_id',
        'meta_title',
        'meta_description',
        'tags',
        'is_published',
        'is_featured',
        'views_count',
        'likes_count',
        'comments_count',
        'published_at'
    ];

    protected $casts = [
        'is_published' => 'boolean',
        'is_featured' => 'boolean',
        'tags' => 'array',
        'views_count' => 'integer',
        'likes_count' => 'integer',
        'comments_count' => 'integer',
        'published_at' => 'datetime'
    ];

    protected $appends = ['image_full_url'];

    // العلاقة مع القسم
    public function category()
    {
        return $this->belongsTo(BlogCategory::class, 'category_id');
    }

    // العلاقة مع التعليقات
    public function comments()
    {
        return $this->hasMany(BlogComment::class, 'post_id');
    }

    // العلاقة مع Storage
    public function storage()
    {
        return $this->morphMany(Storage::class, 'data');
    }

    // العلاقة مع التعليقات المعتمدة فقط
    public function approvedComments()
    {
        return $this->hasMany(BlogComment::class, 'post_id')->where('is_approved', true);
    }

    // إنشاء slug تلقائياً وإدارة الصور
    protected static function boot()
    {
        parent::boot();
        
        // إضافة global scope للـ storage مثل المنتجات
        static::addGlobalScope('storage', function ($builder) {
            $builder->with('storage');
        });
        
        static::creating(function ($post) {
            if (empty($post->slug)) {
                $post->slug = Str::slug($post->title);
            }
            if ($post->is_published && empty($post->published_at)) {
                $post->published_at = now();
            }
        });
        
        static::updating(function ($post) {
            if ($post->isDirty('title') && empty($post->slug)) {
                $post->slug = Str::slug($post->title);
            }
            if ($post->isDirty('is_published') && $post->is_published && empty($post->published_at)) {
                $post->published_at = now();
            }
        });

        static::saved(function ($model) {
            if($model->isDirty('featured_image')){
                $value = Helpers::getDisk();

                DB::table('storages')->updateOrInsert([
                    'data_type' => get_class($model),
                    'data_id' => $model->id,
                    'key' => 'featured_image',
                ], [
                    'value' => $value,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        });
    }

    // Scope للمقالات المنشورة
    public function scopePublished($query)
    {
        return $query->where('is_published', true);
    }

    // Scope للمقالات المميزة
    public function scopeFeatured($query)
    {
        return $query->where('is_featured', true);
    }

    // الحصول على مقتطف المقال
    public function getExcerptAttribute($value)
    {
        if (empty($value) && !empty($this->content)) {
            return Str::limit(strip_tags($this->content), 150);
        }
        return $value;
    }

    // زيادة عدد المشاهدات
    public function incrementViews()
    {
        $this->increment('views_count');
    }

    // زيادة عدد الإعجابات
    public function incrementLikes()
    {
        $this->increment('likes_count');
    }

    // تحديث عدد التعليقات
    public function updateCommentsCount()
    {
        $this->update(['comments_count' => $this->comments()->count()]);
    }

    // الحصول على رابط الصورة المميزة للـ API
    public function getFeaturedImageAttribute($value)
    {
        if ($value) {
            if (str_starts_with($value, 'http')) {
                return $value;
            }
            return asset('storage/' . $value);
        }
        return null;
    }

    // الحصول على رابط الصورة المميزة للعرض في الـ admin (نفس طريقة المنتجات)
    public function getImageFullUrlAttribute()
    {
        $value = $this->getRawOriginal('featured_image');
        if (count($this->storage) > 0) {
            foreach ($this->storage as $storage) {
                if ($storage['key'] == 'featured_image') {
                    return Helpers::get_full_url('blog/posts', $value, $storage['value']);
                }
            }
        }
        return Helpers::get_full_url('blog/posts', $value, 'public');
    }

    // للحفاظ على التوافق مع الكود القديم
    public function getFeaturedImageUrlAttribute()
    {
        return $this->image_full_url;
    }

}