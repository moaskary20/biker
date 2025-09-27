@extends('layouts.admin.app')

@section('title', 'Edit Comment')

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
            <span>Edit Comment</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.comments.index')}}" class="btn btn-secondary">
                <i class="tio-arrow-backward"></i> Back to List
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-body">
                                                                                                                                                                                                                                                                                                                                                                                                                <form action="{{route('admin.blog.comments.update', $comment)}}" method="post">
                        @csrf
                        @method('PUT')
                        
                        <div class="form-group">
                            <label class="input-label">اسم المعلق <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control" value="{{old('name', $comment->name)}}" required>
                            @error('name')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">البريد الإلكتروني <span class="text-danger">*</span></label>
                            <input type="email" name="email" class="form-control" value="{{old('email', $comment->email)}}" required>
                            @error('email')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">الموقع الإلكتروني</label>
                            <input type="url" name="website" class="form-control" value="{{old('website', $comment->website)}}" placeholder="https://example.com">
                            @error('website')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">التعليق <span class="text-danger">*</span></label>
                            <textarea name="comment" class="form-control" rows="6" required>{{old('comment', $comment->comment)}}</textarea>
                            @error('comment')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" name="is_approved" class="custom-control-input" id="isApproved" value="1" {{old('is_approved', $comment->is_approved) ? 'checked' : ''}}>
                                        <label class="custom-control-label" for="isApproved">معتمد</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" name="is_spam" class="custom-control-input" id="isSpam" value="1" {{old('is_spam', $comment->is_spam) ? 'checked' : ''}}>
                                        <label class="custom-control-label" for="isSpam">Spam</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="btn--container justify-content-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="tio-save"></i> حفظ التغييرات
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">معلومات التعليق</h5>
                </div>
                <div class="card-body">
                    <div class="list-group list-group-flush">
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>المقال:</span>
                            <a href="{{route('admin.blog.posts.show', $comment->post_id)}}" class="text-primary">
                                {{Str::limit($comment->post->title, 20)}}
                            </a>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>تاريخ التعليق:</span>
                            <span>{{$comment->created_at->format('Y-m-d H:i')}}</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>آخر تحديث:</span>
                            <span>{{$comment->updated_at->format('Y-m-d H:i')}}</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>عنوان IP:</span>
                            <span>{{$comment->ip_address ?? 'غير محدد'}}</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card mt-3">
                <div class="card-header">
                    <h5 class="card-title">إجراءات سريعة</h5>
                </div>
                <div class="card-body">
                    <a href="{{route('admin.blog.posts.show', $comment->post_id)}}" class="btn btn-outline-info btn-block mb-2">
                        <i class="tio-document"></i> عرض المقال
                    </a>
                    @if(!$comment->is_approved && !$comment->is_spam)
                        <button type="button" class="btn btn-outline-success btn-block mb-2" onclick="approveComment({{$comment->id}})">
                            <i class="tio-checkmark"></i> موافقة سريعة
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

