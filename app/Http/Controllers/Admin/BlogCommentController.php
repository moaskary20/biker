<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\BlogComment;
use App\Models\BlogPost;
use Illuminate\Http\Request;

class BlogCommentController extends Controller
{
    /**
     * عرض قائمة التعليقات
     */
    public function index(Request $request)
    {
        $query = BlogComment::with(['post', 'parent']);

        // فلترة حسب الحالة
        if ($request->filled('status')) {
            switch ($request->status) {
                case 'approved':
                    $query->approved();
                    break;
                case 'pending':
                    $query->pending();
                    break;
                case 'spam':
                    $query->where('is_spam', true);
                    break;
            }
        }

        // فلترة حسب المقال
        if ($request->filled('post_id')) {
            $query->where('post_id', $request->post_id);
        }

        // البحث
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('comment', 'like', "%{$search}%");
            });
        }

        $comments = $query->orderBy('created_at', 'desc')->paginate(15);
        $posts = BlogPost::published()->get();

        return view('admin.blog.comments.index', compact('comments', 'posts'));
    }

    /**
     * عرض تفاصيل التعليق
     */
    public function show(BlogComment $comment)
    {
        $comment->load(['post', 'parent', 'replies']);
        return view('admin.blog.comments.show', compact('comment'));
    }

    /**
     * عرض نموذج تعديل التعليق
     */
    public function edit(BlogComment $comment)
    {
        return view('admin.blog.comments.edit', compact('comment'));
    }

    /**
     * تحديث التعليق
     */
    public function update(Request $request, BlogComment $comment)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
            'comment' => 'required|string',
            'website' => 'nullable|url|max:255',
            'is_approved' => 'boolean',
            'is_spam' => 'boolean'
        ]);

        $oldApprovedStatus = $comment->is_approved;
        
        $comment->update($request->all());

        // تحديث عدد التعليقات في المقال إذا تغيرت حالة الموافقة
        if ($oldApprovedStatus !== $comment->is_approved) {
            $comment->post->updateCommentsCount();
        }

        return redirect()->route('admin.blog.comments.index')
            ->with('success', 'تم تحديث التعليق بنجاح');
    }

    /**
     * حذف التعليق
     */
    public function destroy(BlogComment $comment)
    {
        $post = $comment->post;
        $comment->delete();
        
        // تحديث عدد التعليقات في المقال
        $post->updateCommentsCount();

        return redirect()->route('admin.blog.comments.index')
            ->with('success', 'تم حذف التعليق بنجاح');
    }

    /**
     * الموافقة على التعليق
     */
    public function approve(BlogComment $comment)
    {
        $comment->approve();

        return response()->json(['message' => 'تم الموافقة على التعليق']);
    }

    /**
     * رفض التعليق
     */
    public function reject(BlogComment $comment)
    {
        $comment->reject();

        return response()->json(['message' => 'تم رفض التعليق']);
    }

    /**
     * تحديد التعليق كـ spam
     */
    public function markAsSpam(BlogComment $comment)
    {
        $comment->markAsSpam();

        return response()->json(['message' => 'تم تحديد التعليق كـ spam']);
    }

    /**
     * الموافقة على عدة تعليقات
     */
    public function bulkApprove(Request $request)
    {
        $request->validate([
            'comment_ids' => 'required|array',
            'comment_ids.*' => 'exists:blog_comments,id'
        ]);

        $comments = BlogComment::whereIn('id', $request->comment_ids)->get();
        
        foreach ($comments as $comment) {
            $comment->approve();
        }

        return response()->json(['message' => 'تم الموافقة على التعليقات المحددة']);
    }

    /**
     * حذف عدة تعليقات
     */
    public function bulkDelete(Request $request)
    {
        $request->validate([
            'comment_ids' => 'required|array',
            'comment_ids.*' => 'exists:blog_comments,id'
        ]);

        $comments = BlogComment::whereIn('id', $request->comment_ids)->get();
        $postIds = $comments->pluck('post_id')->unique();
        
        foreach ($comments as $comment) {
            $comment->delete();
        }

        // تحديث عدد التعليقات في المقالات المتأثرة
        foreach ($postIds as $postId) {
            $post = BlogPost::find($postId);
            if ($post) {
                $post->updateCommentsCount();
            }
        }

        return response()->json(['message' => 'تم حذف التعليقات المحددة']);
    }

    /**
     * عرض تعليقات مقال معين
     */
    public function postComments(BlogPost $post)
    {
        $comments = $post->comments()->with('replies')->orderBy('created_at', 'desc')->get();
        return view('admin.blog.comments.post-comments', compact('post', 'comments'));
    }
}