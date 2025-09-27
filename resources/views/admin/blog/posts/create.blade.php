@extends('layouts.admin.app')

@section('title', 'Add New Post')

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
            <span>Add New Post</span>
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
                    <form action="{{route('admin.blog.posts.store')}}" method="post" enctype="multipart/form-data">
                        @csrf
                        
                        <div class="form-group">
                            <label class="input-label">Post Title <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control" value="{{old('title')}}" required>
                            @error('title')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">Category <span class="text-danger">*</span></label>
                            <select name="category_id" class="form-control" required>
                                <option value="">Choose Category</option>
                                @foreach($categories as $category)
                                    <option value="{{$category->id}}" {{old('category_id') == $category->id ? 'selected' : ''}}>
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
                            <textarea name="excerpt" class="form-control" rows="3" placeholder="Brief summary about the post">{{old('excerpt')}}</textarea>
                            @error('excerpt')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">محتوى المقال <span class="text-danger">*</span></label>
                            <textarea name="content" class="form-control blog-editor" rows="15" required>{{old('content')}}</textarea>
                            @error('content')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">صورة المقال المميزة</label>
                            <div class="custom-file">
                                <input type="file" name="featured_image" class="custom-file-input" id="imageUpload" accept="image/*">
                                <label class="custom-file-label" for="imageUpload">اختر صورة</label>
                            </div>
                            @error('featured_image')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                            <div id="imagePreview" class="mt-2" style="display: none;">
                                <img id="previewImg" src="" class="img-thumbnail" style="max-width: 300px;">
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="input-label">التاغز</label>
                            <input type="text" name="tags" class="form-control" value="{{old('tags')}}" placeholder="اكتب التاغز مفصولة بفواصل (tag1, tag2, tag3)">
                            @error('tags')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">عنوان SEO</label>
                            <input type="text" name="meta_title" class="form-control" value="{{old('meta_title')}}" placeholder="عنوان الصفحة في محركات البحث">
                            @error('meta_title')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">وصف SEO</label>
                            <textarea name="meta_description" class="form-control" rows="3" placeholder="وصف الصفحة في محركات البحث">{{old('meta_description')}}</textarea>
                            @error('meta_description')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" name="is_published" class="custom-control-input" id="isPublished" value="1" {{old('is_published') ? 'checked' : ''}}>
                                        <label class="custom-control-label" for="isPublished">نشر المقال</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" name="is_featured" class="custom-control-input" id="isFeatured" value="1" {{old('is_featured') ? 'checked' : ''}}>
                                        <label class="custom-control-label" for="isFeatured">مقال مميز</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="btn--container justify-content-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="tio-save"></i> حفظ المقال
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">نصائح لكتابة المقال</h5>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            اكتب عنوان جذاب وواضح
                        </li>
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            استخدم صور عالية الجودة
                        </li>
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            قسم المحتوى بعناوين فرعية
                        </li>
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            استخدم التاغز المناسبة
                        </li>
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            اكتب وصف SEO مفيد
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

