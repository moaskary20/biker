@extends('layouts.admin.app')

@section('title', 'Blog Comments Management')

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
            <span>Blog Comments Management</span>
        </h1>
    </div>

    <!-- Filters -->
    <div class="blog-filter">
        <form method="GET" class="row">
            <div class="col-md-3">
                <select name="status" class="form-control">
                    <option value="">All Status</option>
                    <option value="approved" {{request('status') == 'approved' ? 'selected' : ''}}>Approved</option>
                    <option value="pending" {{request('status') == 'pending' ? 'selected' : ''}}>Pending</option>
                    <option value="spam" {{request('status') == 'spam' ? 'selected' : ''}}>Spam</option>
                </select>
            </div>
            <div class="col-md-3">
                <select name="post_id" class="form-control">
                    <option value="">All Posts</option>
                    @foreach($posts as $post)
                        <option value="{{$post->id}}" {{request('post_id') == $post->id ? 'selected' : ''}}>
                            {{Str::limit($post->title, 30)}}
                        </option>
                    @endforeach
                </select>
            </div>
            <div class="col-md-4">
                <input type="text" name="search" class="form-control" placeholder="Search in comments..." value="{{request('search')}}">
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
                    @if($comments->count() > 0)
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="thead-light">
                                    <tr>
                                        <th>
                                            <input type="checkbox" id="selectAll">
                                        </th>
                                        <th>Commenter</th>
                                        <th>Comment</th>
                                        <th>Post</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($comments as $comment)
                                        <tr>
                                            <td>
                                                <input type="checkbox" class="comment-checkbox" value="{{$comment->id}}">
                                            </td>
                                            <td>
                                                <div>
                                                    <strong>{{$comment->name}}</strong>
                                                    <br>
                                                    <small class="text-muted">{{$comment->email}}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="blog-comment {{$comment->is_approved ? 'approved' : ($comment->is_spam ? 'spam' : 'pending')}}">
                                                    {{Str::limit($comment->comment, 100)}}
                                                </div>
                                            </td>
                                            <td>
                                                <a href="{{route('admin.blog.posts.show', $comment->post_id)}}" class="text-primary">
                                                    {{Str::limit($comment->post->title, 30)}}
                                                </a>
                                            </td>
                                            <td>
                                                @if($comment->is_spam)
                                                    <span class="badge badge-danger">Spam</span>
                                                @elseif($comment->is_approved)
                                                    <span class="badge badge-success">Approved</span>
                                                @else
                                                    <span class="badge badge-warning">Pending</span>
                                                @endif
                                            </td>
                                            <td>
                                                <small>{{$comment->created_at->format('Y-m-d H:i')}}</small>
                                            </td>
                                            <td>
                                                <div class="btn--container justify-content-center">
                                                    <a class="btn btn-sm btn-outline-primary" href="{{route('admin.blog.comments.show', $comment)}}" title="View">
                                                        <i class="tio-visible"></i>
                                                    </a>
                                                    @if(!$comment->is_approved && !$comment->is_spam)
                                                        <button type="button" class="btn btn-sm btn-outline-success" onclick="approveComment({{$comment->id}})" title="Approve">
                                                            <i class="tio-checkmark"></i>
                                                        </button>
                                                    @endif
                                                    @if(!$comment->is_spam)
                                                        <button type="button" class="btn btn-sm btn-outline-warning" onclick="markSpam({{$comment->id}})" title="Mark as Spam">
                                                            <i class="tio-flag"></i>
                                                        </button>
                                                    @endif
                                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteComment({{$comment->id}})" title="Delete">
                                                        <i class="tio-delete"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Bulk Actions -->
                        <div class="card-footer border-0 bg-light">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <button type="button" class="btn btn-success" onclick="bulkApprove()">
                                        <i class="tio-checkmark"></i> Approve Selected
                                    </button>
                                    <button type="button" class="btn btn-danger" onclick="bulkDelete()">
                                        <i class="tio-delete"></i> Delete Selected
                                    </button>
                                </div>
                                <div class="col-md-6 text-right">
                                    @if($comments->hasPages())
                                        {{$comments->links()}}
                                    @endif
                                </div>
                            </div>
                        </div>
                    @else
                        <div class="blog-empty-state">
                            <img src="{{asset('public/assets/admin/img/empty-state.png')}}" alt="No comments found">
                            <p>No comments found yet</p>
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
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this comment?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <form id="deleteForm" method="POST" style="display: inline;">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger">Delete</button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection

@push('script_2')
<script>
    // Select All Checkbox
    document.getElementById('selectAll').addEventListener('change', function() {
        const checkboxes = document.querySelectorAll('.comment-checkbox');
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.checked;
        });
    });

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

    function bulkApprove() {
        const selectedIds = Array.from(document.querySelectorAll('.comment-checkbox:checked')).map(cb => cb.value);
        if (selectedIds.length === 0) {
            alert('يرجى اختيار تعليقات للموافقة عليها');
            return;
        }
        
        $.post('{{route("admin.blog.comments.bulk-approve")}}', {
            comment_ids: selectedIds,
            _token: '{{csrf_token()}}'
        }, function(data) {
            toastr.success(data.message);
            location.reload();
        });
    }

    function bulkDelete() {
        const selectedIds = Array.from(document.querySelectorAll('.comment-checkbox:checked')).map(cb => cb.value);
        if (selectedIds.length === 0) {
            alert('يرجى اختيار تعليقات للحذف');
            return;
        }
        
        if (confirm('هل أنت متأكد من حذف التعليقات المحددة؟')) {
            $.post('{{route("admin.blog.comments.bulk-delete")}}', {
                comment_ids: selectedIds,
                _token: '{{csrf_token()}}'
            }, function(data) {
                toastr.success(data.message);
                location.reload();
            });
        }
    }
</script>
@endpush

