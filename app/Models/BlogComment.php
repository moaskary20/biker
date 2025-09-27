<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BlogComment extends Model
{
    use HasFactory;

    protected $fillable = [
        'post_id',
        'parent_id',
        'name',
        'email',
        'comment',
        'website',
        'is_approved',
        'is_spam',
        'ip_address',
        'user_agent'
    ];

    protected $casts = [
        'is_approved' => 'boolean',
        'is_spam' => 'boolean'
    ];

    // العلاقة مع المقال
    public function post()
    {
        return $this->belongsTo(BlogPost::class, 'post_id');
    }

    // العلاقة مع التعليق الأب (للردود)
    public function parent()
    {
        return $this->belongsTo(BlogComment::class, 'parent_id');
    }

    // العلاقة مع الردود
    public function replies()
    {
        return $this->hasMany(BlogComment::class, 'parent_id');
    }

    // Scope للتعليقات المعتمدة
    public function scopeApproved($query)
    {
        return $query->where('is_approved', true);
    }

    // Scope للتعليقات غير المعتمدة
    public function scopePending($query)
    {
        return $query->where('is_approved', false);
    }

    // Scope للتعليقات غير المحددة كـ spam
    public function scopeNotSpam($query)
    {
        return $query->where('is_spam', false);
    }

    // الحصول على تاريخ النشر بشكل جميل
    public function getFormattedDateAttribute()
    {
        return $this->created_at->diffForHumans();
    }

    // التحقق من وجود ردود
    public function hasReplies()
    {
        return $this->replies()->count() > 0;
    }

    // الموافقة على التعليق
    public function approve()
    {
        $this->update(['is_approved' => true]);
        
        // تحديث عدد التعليقات في المقال
        $this->post->updateCommentsCount();
    }

    // رفض التعليق
    public function reject()
    {
        $this->update(['is_approved' => false]);
        
        // تحديث عدد التعليقات في المقال
        $this->post->updateCommentsCount();
    }

    // تحديد التعليق كـ spam
    public function markAsSpam()
    {
        $this->update(['is_spam' => true, 'is_approved' => false]);
        
        // تحديث عدد التعليقات في المقال
        $this->post->updateCommentsCount();
    }
}