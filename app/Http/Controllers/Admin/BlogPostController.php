<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\BlogCategory;
use App\Models\BlogPost;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;

class BlogPostController extends Controller
{
    /**
     * عرض قائمة المقالات
     */
    public function index(Request $request)
    {
        $query = BlogPost::with('category');

        // فلترة حسب القسم
        if ($request->filled('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // فلترة حسب الحالة
        if ($request->filled('status')) {
            if ($request->status === 'published') {
                $query->where('is_published', true);
            } elseif ($request->status === 'draft') {
                $query->where('is_published', false);
            }
        }

        // البحث
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                  ->orWhere('content', 'like', "%{$search}%");
            });
        }

        $posts = $query->orderBy('created_at', 'desc')->paginate(10);
        $categories = BlogCategory::active()->get();

        return view('admin.blog.posts.index', compact('posts', 'categories'));
    }

    /**
     * عرض نموذج إنشاء مقال جديد
     */
    public function create()
    {
        $categories = BlogCategory::active()->get();
        return view('admin.blog.posts.create', compact('categories'));
    }

    /**
     * حفظ المقال الجديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'excerpt' => 'nullable|string|max:500',
            'featured_image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'category_id' => 'required|exists:blog_categories,id',
            'tags' => 'nullable|string',
            'meta_title' => 'nullable|string|max:255',
            'meta_description' => 'nullable|string|max:500',
            'is_published' => 'boolean',
            'is_featured' => 'boolean'
        ]);

        $data = $request->all();
        
        // إنشاء slug
        $data['slug'] = Str::slug($request->title);
        
        // معالجة التاغز
        if ($request->tags) {
            $data['tags'] = array_map('trim', explode(',', $request->tags));
        }

        // رفع الصورة المميزة
        if ($request->hasFile('featured_image')) {
            $data['featured_image'] = $request->file('featured_image')->store('blog/posts', 'public');
        }

        // تحديد تاريخ النشر
        if ($request->is_published) {
            $data['published_at'] = now();
        }

        BlogPost::create($data);

        return redirect()->route('admin.blog.posts.index')
            ->with('success', 'تم إنشاء المقال بنجاح');
    }

    /**
     * عرض تفاصيل المقال
     */
    public function show(BlogPost $post)
    {
        $post->load(['category', 'comments']);
        return view('admin.blog.posts.show', compact('post'));
    }

    /**
     * عرض نموذج تعديل المقال
     */
    public function edit(BlogPost $post)
    {
        $categories = BlogCategory::active()->get();
        return view('admin.blog.posts.edit', compact('post', 'categories'));
    }

    /**
     * تحديث المقال
     */
    public function update(Request $request, BlogPost $post)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'content' => 'required|string',
            'excerpt' => 'nullable|string|max:500',
            'featured_image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'category_id' => 'required|exists:blog_categories,id',
            'tags' => 'nullable|string',
            'meta_title' => 'nullable|string|max:255',
            'meta_description' => 'nullable|string|max:500',
            'is_published' => 'boolean',
            'is_featured' => 'boolean'
        ]);

        $data = $request->all();
        
        // إنشاء slug جديد إذا تغير العنوان
        if ($request->title !== $post->title) {
            $data['slug'] = Str::slug($request->title);
        }

        // معالجة التاغز
        if ($request->tags) {
            $data['tags'] = array_map('trim', explode(',', $request->tags));
        }

        // رفع صورة جديدة
        if ($request->hasFile('featured_image')) {
            // حذف الصورة القديمة
            if ($post->featured_image) {
                Storage::disk('public')->delete($post->featured_image);
            }
            $data['featured_image'] = $request->file('featured_image')->store('blog/posts', 'public');
        }

        // تحديد تاريخ النشر
        if ($request->is_published && !$post->is_published) {
            $data['published_at'] = now();
        }

        $post->update($data);

        return redirect()->route('admin.blog.posts.index')
            ->with('success', 'تم تحديث المقال بنجاح');
    }

    /**
     * حذف المقال
     */
    public function destroy(BlogPost $post)
    {
        // حذف الصورة
        if ($post->featured_image) {
            Storage::disk('public')->delete($post->featured_image);
        }

        $post->delete();

        return redirect()->route('admin.blog.posts.index')
            ->with('success', 'تم حذف المقال بنجاح');
    }

    /**
     * تغيير حالة النشر
     */
    public function togglePublish(BlogPost $post)
    {
        $data = ['is_published' => !$post->is_published];
        
        if ($data['is_published'] && !$post->published_at) {
            $data['published_at'] = now();
        }

        $post->update($data);
        
        $status = $post->is_published ? 'منشور' : 'مسودة';
        return response()->json(['message' => "تم تغيير حالة المقال إلى {$status}"]);
    }

    /**
     * تغيير حالة التميز
     */
    public function toggleFeatured(BlogPost $post)
    {
        $post->update(['is_featured' => !$post->is_featured]);
        
        $status = $post->is_featured ? 'مميز' : 'عادي';
        return response()->json(['message' => "تم تغيير حالة المقال إلى {$status}"]);
    }
}