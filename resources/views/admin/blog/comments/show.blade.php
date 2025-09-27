@extends('layouts.admin.app')

@section('title', 'عرض التعليق')

@push('css_or_js')
<link rel="stylesheet" href="{{asset('public/assets/admin/css/blog.css')}}">
@endpush

@section('content')
<div class="content container-fluid">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-header-title">
            <span class="page-header-icon">
                <i class="tio-comment"></i>
            </span>
            <span>عرض التعليق</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.comments.index')}}" class="btn btn-secondary">
                <i class="tio-arrow-backward"></i> العودة للقائمة
            </a>
            <a href="{{route('admin.blog.comments.edit', $comment)}}" class="btn btn-primary">
                <i class="tio-edit"></i> تعديل
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">تفاصيل التعليق</h5>
                </div>
                <div class="card-body">
                    <div class="blog-comment {{$comment->is_approved ? 'approved' : ($comment->is_spam ? 'spam' : 'pending')}}">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h6 class="mb-1">{{$comment->name}}</h6>
                                <small class="text-muted">{{$comment->email}}</small>
                                @if($comment->website)
                                    <br>
                                    <small class="text-muted">
                                        <a href="{{$comment->website}}" target="_blank">{{$comment->website}}</a>
                                    </small>
                                @endif
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
                        
                        <div class="comment-content">
                            <p class="mb-0">{{$comment->comment}}</p>
                        </div>
                        
                        <div class="comment-meta mt-3">
                            <small class="text-muted">
                                <i class="tio-time"></i> {{$comment->created_at->format('Y-m-d H:i')}} 
                                ({{$comment->created_at->diffForHumans()}})
                            </small>
                            @if($comment->ip_address)
                                <small class="text-muted ml-3">
                                    <i class="tio-globe"></i> {{$comment->ip_address}}
                                </small>
                            @endif
                        </div>
                    </div>
                </div>
            </div>

            <!-- المقال المرتبط -->
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">المقال المرتبط</h5>
                </div>
                <div class="card-body">
                    <div class="media">
                        @if($comment->post->featured_image)
                            <img src="{{asset('storage/' . $comment->post->featured_image)}}" class="img--40 mr-3" alt="{{$comment->post->title}}">
                        @endif
                        <div class="media-body">
                            <h6 class="mt-0">
                                <a href="{{route('admin.blog.posts.show', $comment->post_id)}}" class="text-primary">
                                    {{$comment->post->title}}
                                </a>
                            </h6>
                            <p class="text-muted mb-0">{{Str::limit($comment->post->excerpt, 100)}}</p>
                            <small class="text-muted">
                                القسم: {{$comment->post->category->name}} | 
                                تاريخ النشر: {{$comment->post->created_at->format('Y-m-d')}}
                            </small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- الردود إن وجدت -->
            @if($comment->replies->count() > 0)
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title">الردود ({{$comment->replies->count()}})</h5>
                    </div>
                    <div class="card-body">
                        @foreach($comment->replies as $reply)
                            <div class="blog-comment {{$reply->is_approved ? 'approved' : ($reply->is_spam ? 'spam' : 'pending')}} ml-4">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div>
                                        <strong>{{$reply->name}}</strong>
                                        <small class="text-muted">({{$reply->email}})</small>
                                    </div>
                                    <div>
                                        @if($reply->is_spam)
                                            <span class="badge badge-danger">Spam</span>
                                        @elseif($reply->is_approved)
                                            <span class="badge badge-success">معتمد</span>
                                        @else
                                            <span class="badge badge-warning">في الانتظار</span>
                                        @endif
                                    </div>
                                </div>
                                <p class="mb-2">{{$reply->comment}}</p>
                                <small class="text-muted">{{$reply->created_at->format('Y-m-d H:i')}}</small>
                            </div>
                        @endforeach
                    </div>
                </div>
            @endif
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">معلومات التعليق</h5>
                </div>
                <div class="card-body">
                    <table class="table table-sm table-borderless">
                        <tr>
                            <td><strong>المعلق:</strong></td>
                            <td>{{$comment->name}}</td>
                        </tr>
                        <tr>
                            <td><strong>البريد:</strong></td>
                            <td>{{$comment->email}}</td>
                        </tr>
                        @if($comment->website)
                        <tr>
                            <td><strong>الموقع:</strong></td>
                            <td><a href="{{$comment->website}}" target="_blank">{{$comment->website}}</a></td>
                        </tr>
                        @endif
                        <tr>
                            <td><strong>عنوان IP:</strong></td>
                            <td>{{$comment->ip_address ?? 'غير محدد'}}</td>
                        </tr>
                        <tr>
                            <td><strong>تاريخ التعليق:</strong></td>
                            <td>{{$comment->created_at->format('Y-m-d H:i')}}</td>
                        </tr>
                        <tr>
                            <td><strong>آخر تحديث:</strong></td>
                            <td>{{$comment->updated_at->format('Y-m-d H:i')}}</td>
                        </tr>
                        <tr>
                            <td><strong>عدد الردود:</strong></td>
                            <td><span class="badge badge-soft-info">{{$comment->replies->count()}}</span></td>
                        </tr>
                    </table>
                </div>
            </div>
            
            <div class="card mt-3">
                <div class="card-header">
                    <h5 class="card-title">إجراءات سريعة</h5>
                </div>
                <div class="card-body">
                    <a href="{{route('admin.blog.comments.edit', $comment)}}" class="btn btn-outline-primary btn-block mb-2">
                        <i class="tio-edit"></i> تعديل التعليق
                    </a>
                    <a href="{{route('admin.blog.posts.show', $comment->post_id)}}" class="btn btn-outline-info btn-block mb-2">
                        <i class="tio-document"></i> عرض المقال
                    </a>
                    
                    @if(!$comment->is_approved && !$comment->is_spam)
                        <button type="button" class="btn btn-outline-success btn-block mb-2" onclick="approveComment({{$comment->id}})">
                            <i class="tio-checkmark"></i> موافقة
                        </button>
                    @endif
                    
                    @if(!$comment->is_spam)
                        <button type="button" class="btn btn-outline-warning btn-block mb-2" onclick="markSpam({{$comment->id}})">
                            <i class="tio-flag"></i> تحديد كـ spam
                        </button>
                    @endif
                    
                    <button type="button" class="btn btn-outline-danger btn-block" onclick="deleteComment({{$comment->id}})">
                        <i class="tio-delete"></i> حذف التعليق
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
                هل أنت متأكد من حذف هذا التعليق؟
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
    function approveComment(id) {
        $.get('{{url("/")}}/admin/blog/comments/' + id + '/approve', function(data) {
            toastr.success(data.message);
            location.reload();
        });
    }

    function markSpam(id) {
        if (confirm('هل أنت متأكد من تحديد هذا التعليق كـ spam؟')) {
            $.get('{{url("/")}}/admin/blog/comments/' + id + '/mark-spam', function(data) {
                toastr.success(data.message);
                location.reload();
            });
        }
    }

    function deleteComment(id) {
        $('#deleteForm').attr('action', '{{url("/")}}/admin/blog/comments/' + id);
        $('#deleteModal').modal('show');
    }
</script>
@endpush

