@extends('layouts.admin.app')

@section('title', 'Edit Post')

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
            <span>Edit Post: {{$post->title}}</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.posts.index')}}" class="btn btn-secondary">
                <i class="tio-arrow-backward"></i> Back to List
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-body">
                    <form action="{{route('admin.blog.posts.update', $post)}}" method="post" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')
                        
                        <div class="form-group">
                            <label class="input-label">Post Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" value="{{old('title', $post->title)}}" required>
                            @error('title')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">Category <span class="text-danger">*</span></label>
                            <select name="category_id" class="form-control" required>
                                <option value="">Select Category</option>
                                @foreach($categories as $category)
                                    <option value="{{$category->id}}" {{old('category_id', $post->category_id) == $category->id ? 'selected' : ''}}>
                                        {{$category->name}}
                                    </option>
                                @endforeach
                            </select>
                            @error('category_id')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">Post Excerpt</label>
                            <textarea name="excerpt" class="form-control" rows="3" placeholder="Brief summary of the post">{{old('excerpt', $post->excerpt)}}</textarea>
                            @error('excerpt')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">Post Content <span class="text-danger">*</span></label>
                            <textarea name="content" class="form-control blog-editor" rows="15" required>{{old('content', $post->content)}}</textarea>
                            @error('content')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">Featured Image</label>
                            
                            @if($post->featured_image_url)
                                <div class="mb-2">
                                    <img src="{{$post->featured_image_url}}" class="img-thumbnail" style="max-width: 300px;" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';" onload="console.log('Current image loaded:', this.src)">
                                    <div style="display: none;">
                                        <div class="bg-light d-flex align-items-center justify-content-center img-thumbnail" style="max-width: 300px; height: 200px;">
                                            <i class="tio-image text-muted"></i>
                                        </div>
                                        <p class="text-muted small">Image not available</p>
                                    </div>
                                    <p class="text-muted small">Current image</p>
                                </div>
                            @endif
                            
                            <div class="custom-file">
                                <input type="file" name="featured_image" class="custom-file-input" id="imageUpload" accept="image/*">
                                <label class="custom-file-label" for="imageUpload">Choose new image (optional)</label>
                            </div>
                            @error('featured_image')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                            <div id="imagePreview" class="mt-2" style="display: none;">
                                <img id="previewImg" src="" class="img-thumbnail" style="max-width: 300px;">
                                <p class="text-muted small">New image preview</p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="input-label">Tags</label>
                            <input type="text" name="tags" class="form-control" value="{{old('tags', $post->tags ? implode(', ', $post->tags) : '')}}" placeholder="Enter tags separated by commas (tag1, tag2, tag3)">
                            @error('tags')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">SEO Title</label>
                            <input type="text" name="meta_title" class="form-control" value="{{old('meta_title', $post->meta_title)}}" placeholder="Page title for search engines">
                            @error('meta_title')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">SEO Description</label>
                            <textarea name="meta_description" class="form-control" rows="3" placeholder="Page description for search engines">{{old('meta_description', $post->meta_description)}}</textarea>
                            @error('meta_description')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" name="is_published" class="custom-control-input" id="isPublished" value="1" {{old('is_published', $post->is_published) ? 'checked' : ''}}>
                                        <label class="custom-control-label" for="isPublished">Publish Post</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" name="is_featured" class="custom-control-input" id="isFeatured" value="1" {{old('is_featured', $post->is_featured) ? 'checked' : ''}}>
                                        <label class="custom-control-label" for="isFeatured">Featured Post</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="btn--container justify-content-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="tio-save"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">Post Information</h5>
                </div>
                <div class="card-body">
                    <div class="list-group list-group-flush">
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>Views:</span>
                            <span class="badge badge-soft-info">{{$post->views_count}}</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>Comments:</span>
                            <span class="badge badge-soft-success">{{$post->comments_count}}</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>Likes:</span>
                            <span class="badge badge-soft-warning">{{$post->likes_count}}</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>Created Date:</span>
                            <span>{{$post->created_at->format('Y-m-d H:i')}}</span>
                        </div>
                        @if($post->published_at)
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>Published Date:</span>
                            <span>{{$post->published_at->format('Y-m-d H:i')}}</span>
                        </div>
                        @endif
                    </div>
                </div>
            </div>
            
            <div class="card mt-3">
                <div class="card-header">
                    <h5 class="card-title">Quick Actions</h5>
                </div>
                <div class="card-body">
                    <a href="{{route('admin.blog.posts.show', $post)}}" class="btn btn-outline-info btn-block mb-2">
                        <i class="tio-visible"></i> View Post
                    </a>
                    <button type="button" class="btn btn-outline-danger btn-block" onclick="deletePost({{$post->id}})">
                        <i class="tio-delete"></i> Delete Post
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
                <h5 class="modal-title">Confirm Delete</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this post?
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
    // Preview uploaded image
    document.getElementById('imageUpload').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('previewImg').src = e.target.result;
                document.getElementById('imagePreview').style.display = 'block';
            }
            reader.readAsDataURL(file);
        }
    });

    function deletePost(id) {
        $('#deleteForm').attr('action', '{{url("/")}}/admin/blog/posts/' + id);
        $('#deleteModal').modal('show');
    }
</script>
@endpush

