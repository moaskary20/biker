<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\BlogCategory;
use App\Helpers\ImageHelper;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;

class BlogCategoryController extends Controller
{
    /**
     * عرض قائمة الأقسام
     */
    public function index()
    {
        $categories = BlogCategory::with('posts')->orderBy('sort_order')->paginate(15);
        return view('admin.blog.categories.index', compact('categories'));
    }

    /**
     * عرض نموذج إنشاء قسم جديد
     */
    public function create()
    {
        return view('admin.blog.categories.create');
    }

    /**
     * حفظ القسم الجديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:blog_categories,name',
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'meta_title' => 'nullable|string|max:255',
            'meta_description' => 'nullable|string|max:500',
            'is_active' => 'boolean',
            'sort_order' => 'nullable|integer|min:0'
        ]);

        $data = $request->all();
        
        // إنشاء slug
        $data['slug'] = Str::slug($request->name);
        
        // رفع الصورة
        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('blog/categories', 'public');
        }

        BlogCategory::create($data);

        return redirect()->route('admin.blog.categories.index')
            ->with('success', 'تم إنشاء القسم بنجاح');
    }

    /**
     * عرض تفاصيل القسم
     */
    public function show(BlogCategory $category)
    {
        $category->load('posts');
        return view('admin.blog.categories.show', compact('category'));
    }

    /**
     * عرض نموذج تعديل القسم
     */
    public function edit(BlogCategory $category)
    {
        return view('admin.blog.categories.edit', compact('category'));
    }

    /**
     * تحديث القسم
     */
    public function update(Request $request, BlogCategory $category)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:blog_categories,name,' . $category->id,
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'meta_title' => 'nullable|string|max:255',
            'meta_description' => 'nullable|string|max:500',
            'is_active' => 'boolean',
            'sort_order' => 'nullable|integer|min:0'
        ]);

        $data = $request->all();
        
        // إنشاء slug جديد إذا تغير الاسم
        if ($request->name !== $category->name) {
            $data['slug'] = Str::slug($request->name);
        }

        // رفع صورة جديدة
        if ($request->hasFile('image')) {
            // حذف الصورة القديمة
            $oldImage = $category->getRawOriginal('image');
            if ($oldImage) {
                ImageHelper::deleteImage($oldImage, 'blog/categories');
            }
            
            // رفع الصورة الجديدة
            $data['image'] = $request->file('image')->store('blog/categories', 'public');
            
            // تحديث timestamp للصورة الجديدة
            $fullPath = storage_path('app/public/' . $data['image']);
            if (file_exists($fullPath)) {
                touch($fullPath);
            }
        }

        $category->update($data);

        return redirect()->route('admin.blog.categories.index')
            ->with('success', 'تم تحديث القسم بنجاح');
    }

    /**
     * حذف القسم
     */
    public function destroy(BlogCategory $category)
    {
        // حذف الصورة
        ImageHelper::deleteImage($category->getRawOriginal('image'), 'blog/categories');

        $category->delete();

        return redirect()->route('admin.blog.categories.index')
            ->with('success', 'تم حذف القسم بنجاح');
    }

    /**
     * تغيير حالة القسم (نشط/غير نشط)
     */
    public function toggleStatus(BlogCategory $category)
    {
        $category->update(['is_active' => !$category->is_active]);
        
        $status = $category->is_active ? 'نشط' : 'غير نشط';
        return response()->json(['message' => "تم تغيير حالة القسم إلى {$status}"]);
    }
}