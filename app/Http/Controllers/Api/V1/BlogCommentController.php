<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\BlogComment;
use App\Models\BlogPost;
use Illuminate\Http\Request;

class BlogCommentController extends Controller
{
    public function index($postId)
    {
        try {
            $post = BlogPost::find($postId);
            if (!$post) {
                return response()->json([
                    'success' => false,
                    'message' => 'Post not found'
                ], 404);
            }

            $comments = BlogComment::where('post_id', $postId)
                ->where('is_approved', true)
                ->where('is_spam', false)
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'comments' => $comments
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch comments'
            ], 500);
        }
    }

    public function store(Request $request)
    {
        try {
            $request->validate([
                'post_id' => 'required|exists:blog_posts,id',
                'name' => 'required|string|max:255',
                'email' => 'required|email|max:255',
                'comment' => 'required|string|max:1000',
            ]);

            $comment = BlogComment::create([
                'post_id' => $request->post_id,
                'name' => $request->name,
                'email' => $request->email,
                'comment' => $request->comment,
                'is_approved' => false, // Comments need approval
                'is_spam' => false,
                'ip_address' => $request->ip(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Comment submitted successfully and is pending approval',
                'comment' => $comment
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to submit comment'
            ], 500);
        }
    }
}
