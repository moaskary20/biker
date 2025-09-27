@extends('layouts.admin.app')

@section('title', 'Add New Category')

@push('css_or_js')
<link rel="stylesheet" href="{{asset('public/assets/admin/css/blog.css')}}">
@endpush

@section('content')
<div class="content container-fluid">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-header-title">
            <span class="page-header-icon">
                <i class="tio-category"></i>
            </span>
            <span>Add New Category</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.categories.index')}}" class="btn btn-secondary">
                <i class="tio-arrow-backward"></i> Back to List
            </a>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-body">
                    <form action="{{route('admin.blog.categories.store')}}" method="post" enctype="multipart/form-data">
                        @csrf
                        
                        <div class="form-group">
                            <label class="input-label">Category Name <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control" value="{{old('name')}}" required>
                            @error('name')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">Category Description</label>
                            <textarea name="description" class="form-control" rows="4" placeholder="Brief description about the category">{{old('description')}}</textarea>
                            @error('description')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">Category Image</label>
                            <div class="custom-file">
                                <input type="file" name="image" class="custom-file-input" id="imageUpload" accept="image/*">
                                <label class="custom-file-label" for="imageUpload">Choose Image</label>
                            </div>
                            @error('image')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                            <div id="imagePreview" class="mt-2" style="display: none;">
                                <img id="previewImg" src="" class="img-thumbnail" style="max-width: 200px;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="input-label">Sort Order</label>
                            <input type="number" name="sort_order" class="form-control" value="{{old('sort_order', 0)}}" min="0">
                            @error('sort_order')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">SEO Title</label>
                            <input type="text" name="meta_title" class="form-control" value="{{old('meta_title')}}" placeholder="Page title for search engines">
                            @error('meta_title')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">SEO Description</label>
                            <textarea name="meta_description" class="form-control" rows="3" placeholder="Page description for search engines">{{old('meta_description')}}</textarea>
                            @error('meta_description')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" name="is_active" class="custom-control-input" id="isActive" value="1" {{old('is_active', true) ? 'checked' : ''}}>
                                <label class="custom-control-label" for="isActive">Active</label>
                            </div>
                        </div>

                        <div class="btn--container justify-content-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="tio-save"></i> Save Category
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">Tips</h5>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            اختر اسم واضح ومفهوم للقسم
                        </li>
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            اكتب وصف مختصر ومفيد
                        </li>
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            استخدم صورة واضحة وجذابة
                        </li>
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            حدد ترتيب العرض حسب الأولوية
                        </li>
                    </ul>
                </div>
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
</script>
@endpush