@extends('layouts.admin.app')

@section('title', 'Blog Posts Management')

@push('css_or_js')
<link rel="stylesheet" href="{{asset('public/assets/admin/css/blog.css')}}">
@endpush

@section('content')
<div class="content container-fluid">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-header-title">
            <span class="page-header-icon">
                <i class="tio-document"></i>
            </span>
            <span>Blog Posts Management</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.posts.create')}}" class="btn btn-primary">
                <i class="tio-add"></i> Add New Post
            </a>
        </div>
    </div>

    <!-- Filters -->
    <div class="blog-filter">
        <form method="GET" class="row">
            <div class="col-md-3">
                <select name="category_id" class="form-control">
                    <option value="">All Categories</option>
                    @foreach($categories as $category)
                        <option value="{{$category->id}}" {{request('category_id') == $category->id ? 'selected' : ''}}>
                            {{$category->name}}
                        </option>
                    @endforeach
                </select>
            </div>
            <div class="col-md-3">
                <select name="status" class="form-control">
                    <option value="">All Status</option>
                    <option value="published" {{request('status') == 'published' ? 'selected' : ''}}>Published</option>
                    <option value="draft" {{request('status') == 'draft' ? 'selected' : ''}}>Draft</option>
                </select>
            </div>
            <div class="col-md-4">
                <input type="text" name="search" class="form-control" placeholder="Search in posts..." value="{{request('search')}}">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary btn-block">Filter</button>
            </div>
        </form>
    </div>

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body p-0">
                    @if($posts->count() > 0)
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="thead-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Image</th>
                                        <th>Title</th>
                                        <th>Category</th>
                                        <th>Status</th>
                                        <th>Views</th>
                                        <th>Comments</th>
                                        <th>Date</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($posts as $key => $post)
                                        <tr>
                                            <td>{{$posts->firstItem() + $key}}</td>
                                            <td>
                                                @if($post->featured_image)
                                                    @if(str_starts_with($post->featured_image, 'http'))
                                                        <img src="{{$post->featured_image}}" class="blog-image" alt="{{$post->title}}">
                                                    @else
                                                        <img src="{{asset('storage/' . $post->featured_image)}}" class="blog-image" alt="{{$post->title}}">
                                                    @endif
                                                @else
                                                    <div class="blog-image bg-light d-flex align-items-center justify-content-center">
                                                        <i class="tio-image"></i>
                                                    </div>
                                                @endif
                                            </td>
                                            <td>
                                                <h6 class="mb-1">{{Str::limit($post->title, 50)}}</h6>
                                                <small class="text-muted">{{Str::limit(strip_tags($post->excerpt), 80)}}</small>
                                            </td>
                                            <td>
                                                <span class="badge badge-soft-info">{{$post->category->name}}</span>
                                            </td>
                                            <td>
                                                @if($post->is_published)
                                                    <span class="blog-status published">Published</span>
                                                @else
                                                    <span class="blog-status draft">Draft</span>
                                                @endif
                                                @if($post->is_featured)
                                                    <span class="blog-status featured">Featured</span>
                                                @endif
                                            </td>
                                            <td>
                                                <span class="badge badge-soft-secondary">{{$post->views_count}}</span>
                                            </td>
                                            <td>
                                                <span class="badge badge-soft-info">{{$post->comments_count}}</span>
                                            </td>
                                            <td>
                                                @if($post->published_at)
                                                    {{$post->published_at->format('Y-m-d')}}
                                                @else
                                                    <span class="text-muted">لم ينشر</span>
                                                @endif
                                            </td>
                                            <td>
                                                <div class="btn--container justify-content-center">
                                                    <a class="btn btn-sm btn-outline-primary" href="{{route('admin.blog.posts.show', $post)}}" title="عرض">
                                                        <i class="tio-visible"></i>
                                                    </a>
                                                    <a class="btn btn-sm btn-outline-secondary" href="{{route('admin.blog.posts.edit', $post)}}" title="تعديل">
                                                        <i class="tio-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="deletePost({{$post->id}})" title="حذف">
                                                        <i class="tio-delete"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        
                        @if($posts->hasPages())
                            <div class="card-footer border-0">
                                {{$posts->links()}}
                            </div>
                        @endif
                    @else
                        <div class="blog-empty-state">
                            <img src="{{asset('public/assets/admin/img/empty-state.png')}}" alt="لا توجد مقالات">
                            <p>لا توجد مقالات حتى الآن</p>
                            <a class="btn btn-primary" href="{{route('admin.blog.posts.create')}}">إضافة مقال جديد</a>
                        </div>
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">تأكيد الحذف</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                هل أنت متأكد من حذف هذا المقال؟
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">إلغاء</button>
                <form id="deleteForm" method="POST" style="display: inline;">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger">حذف</button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection

@push('script_2')
<script>
    function deletePost(id) {
        $('#deleteForm').attr('action', '{{url("/")}}/admin/blog/posts/' + id);
        $('#deleteModal').modal('show');
    }
</script>
@endpush

