@extends('layouts.admin.app')

@section('title', 'عرض المقال')

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
            <span>عرض المقال: {{$post->title}}</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.posts.index')}}" class="btn btn-secondary">
                <i class="tio-arrow-backward"></i> العودة للقائمة
            </a>
            <a href="{{route('admin.blog.posts.edit', $post)}}" class="btn btn-primary">
                <i class="tio-edit"></i> تعديل
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">محتوى المقال</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8">
                            <h2 class="mb-3">{{$post->title}}</h2>
                            
                            <div class="blog-meta mb-3">
                                <span class="badge badge-soft-info mr-2">{{$post->category->name}}</span>
                                @if($post->is_published)
                                    <span class="blog-status published">منشور</span>
                                @else
                                    <span class="blog-status draft">مسودة</span>
                                @endif
                                @if($post->is_featured)
                                    <span class="blog-status featured">مميز</span>
                                @endif
                            </div>

                            @if($post->featured_image)
                                <img src="{{asset('storage/' . $post->featured_image)}}" class="img-fluid rounded mb-3" alt="{{$post->title}}">
                            @endif

                            @if($post->excerpt)
                                <div class="alert alert-light">
                                    <strong>المقتطف:</strong>
                                    <p class="mb-0">{{$post->excerpt}}</p>
                                </div>
                            @endif

                            <div class="blog-content">
                                {!! $post->content !!}
                            </div>

                            @if($post->tags && count($post->tags) > 0)
                                <div class="blog-tags mt-4">
                                    <h6>التاغز:</h6>
                                    @foreach($post->tags as $tag)
                                        <span class="blog-tag">{{$tag}}</span>
                                    @endforeach
                                </div>
                            @endif
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title">معلومات المقال</h6>
                                </div>
                                <div class="card-body">
                                    <table class="table table-sm table-borderless">
                                        <tr>
                                            <td><strong>القسم:</strong></td>
                                            <td>{{$post->category->name}}</td>
                                        </tr>
                                        <tr>
                                            <td><strong>المشاهدات:</strong></td>
                                            <td><span class="badge badge-soft-info">{{$post->views_count}}</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>التعليقات:</strong></td>
                                            <td><span class="badge badge-soft-success">{{$post->comments_count}}</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>الإعجابات:</strong></td>
                                            <td><span class="badge badge-soft-warning">{{$post->likes_count}}</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>تاريخ الإنشاء:</strong></td>
                                            <td>{{$post->created_at->format('Y-m-d H:i')}}</td>
                                        </tr>
                                        @if($post->published_at)
                                        <tr>
                                            <td><strong>تاريخ النشر:</strong></td>
                                            <td>{{$post->published_at->format('Y-m-d H:i')}}</td>
                                        </tr>
                                        @endif
                                        <tr>
                                            <td><strong>آخر تحديث:</strong></td>
                                            <td>{{$post->updated_at->format('Y-m-d H:i')}}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            @if($post->meta_title || $post->meta_description)
                                <div class="card mt-3">
                                    <div class="card-header">
                                        <h6 class="card-title">معلومات SEO</h6>
                                    </div>
                                    <div class="card-body">
                                        @if($post->meta_title)
                                            <p><strong>عنوان SEO:</strong><br>{{$post->meta_title}}</p>
                                        @endif
                                        @if($post->meta_description)
                                            <p><strong>وصف SEO:</strong><br>{{$post->meta_description}}</p>
                                        @endif
                                    </div>
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </div>

            <!-- تعليقات المقال -->
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">
                        تعليقات المقال ({{$post->comments->count()}})
                        <a href="{{route('admin.blog.comments.index')}}?post_id={{$post->id}}" class="btn btn-sm btn-primary float-right">
                            <i class="tio-comment"></i> إدارة التعليقات
                        </a>
                    </h5>
                </div>
                <div class="card-body">
                    @if($post->comments->count() > 0)
                        @foreach($post->comments->take(5) as $comment)
                            <div class="blog-comment {{$comment->is_approved ? 'approved' : ($comment->is_spam ? 'spam' : 'pending')}}">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <strong>{{$comment->name}}</strong>
                                        <small class="text-muted">({{$comment->email}})</small>
                                        <small class="text-muted float-right">{{$comment->created_at->diffForHumans()}}</small>
                                    </div>
                                    <div>
                                        @if($comment->is_spam)
                                            <span class="badge badge-danger">Spam</span>
                                        @elseif($comment->is_approved)
                                            <span class="badge badge-success">معتمد</span>
                                        @else
                                            <span class="badge badge-warning">في الانتظار</span>
                                        @endif
                                    </div>
                                </div>
                                <p class="mt-2 mb-0">{{$comment->comment}}</p>
                            </div>
                        @endforeach
                        
                        @if($post->comments->count() > 5)
                            <div class="text-center mt-3">
                                <a href="{{route('admin.blog.comments.index')}}?post_id={{$post->id}}" class="btn btn-outline-primary">
                                    عرض جميع التعليقات ({{$post->comments->count()}})
                                </a>
                            </div>
                        @endif
                    @else
                        <div class="text-center py-4">
                            <p class="text-muted">لا توجد تعليقات على هذا المقال</p>
                        </div>
                    @endif
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">إجراءات سريعة</h5>
                </div>
                <div class="card-body">
                    <a href="{{route('admin.blog.posts.edit', $post)}}" class="btn btn-outline-primary btn-block mb-2">
                        <i class="tio-edit"></i> تعديل المقال
                    </a>
                    @if($post->is_published)
                        <button type="button" class="btn btn-outline-warning btn-block mb-2" onclick="togglePublish({{$post->id}})">
                            <i class="tio-eye-off"></i> إلغاء النشر
                        </button>
                    @else
                        <button type="button" class="btn btn-outline-success btn-block mb-2" onclick="togglePublish({{$post->id}})">
                            <i class="tio-eye"></i> نشر المقال
                        </button>
                    @endif
                    
                    @if($post->is_featured)
                        <button type="button" class="btn btn-outline-secondary btn-block mb-2" onclick="toggleFeatured({{$post->id}})">
                            <i class="tio-star-off"></i> إلغاء التميز
                        </button>
                    @else
                        <button type="button" class="btn btn-outline-info btn-block mb-2" onclick="toggleFeatured({{$post->id}})">
                            <i class="tio-star"></i> جعل مميز
                        </button>
                    @endif
                    
                    <a href="{{route('admin.blog.comments.index')}}?post_id={{$post->id}}" class="btn btn-outline-success btn-block mb-2">
                        <i class="tio-comment"></i> إدارة التعليقات
                    </a>
                    <button type="button" class="btn btn-outline-danger btn-block" onclick="deletePost({{$post->id}})">
                        <i class="tio-delete"></i> حذف المقال
                    </button>
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
    function togglePublish(id) {
        $.get('{{url("/")}}/admin/blog/posts/' + id + '/toggle-publish', function(data) {
            toastr.success(data.message);
            location.reload();
        });
    }

    function toggleFeatured(id) {
        $.get('{{url("/")}}/admin/blog/posts/' + id + '/toggle-featured', function(data) {
            toastr.success(data.message);
            location.reload();
        });
    }

    function deletePost(id) {
        $('#deleteForm').attr('action', '{{url("/")}}/admin/blog/posts/' + id);
        $('#deleteModal').modal('show');
    }
</script>
@endpush

