<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\BlogPost;
use App\Models\BlogCategory;
use Illuminate\Http\Request;

class BlogPostController extends Controller
{
    public function index(Request $request)
    {
        try {
            $query = BlogPost::with('category')
                ->where('is_published', true)
                ->orderBy('published_at', 'desc');

            // Filter by category if provided
            if ($request->has('category_id') && $request->category_id) {
                $query->where('category_id', $request->category_id);
            }

            // Pagination
            $perPage = 10;
            $posts = $query->paginate($perPage);

            return response()->json([
                'success' => true,
                'posts' => $posts->items(),
                'pagination' => [
                    'current_page' => $posts->currentPage(),
                    'last_page' => $posts->lastPage(),
                    'per_page' => $posts->perPage(),
                    'total' => $posts->total(),
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch posts'
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $post = BlogPost::with('category')
                ->where('id', $id)
                ->where('is_published', true)
                ->first();

            if (!$post) {
                return response()->json([
                    'success' => false,
                    'message' => 'Post not found'
                ], 404);
            }

            // Increment view count
            $post->increment('views_count');

            return response()->json([
                'success' => true,
                'post' => $post
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to fetch post'
            ], 500);
        }
    }
}
