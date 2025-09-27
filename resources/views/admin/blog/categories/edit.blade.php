@extends('layouts.admin.app')

@section('title', 'Edit Category')

@push('css_or_js')
<link rel="stylesheet" href="{{asset('public/assets/admin/css/blog.css')}}">
@endpush

@section('content')
<div class="content container-fluid">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-header-title">
            <span class="page-header-icon">
                <img src="{{asset('public/assets/admin/img/category.png')}}" class="w--20" alt="">
            </span>
            <span>Edit Category: {{$category->name}}</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.categories.index')}}" class="btn btn-secondary">
                <i class="tio-arrow-backward"></i> Back to List
            </a>
        </div>
    </div>
    <!-- End Page Header -->

    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">Category Information</h5>
                </div>
                <div class="card-body">
                    <form action="{{route('admin.blog.categories.update', $category)}}" method="post" enctype="multipart/form-data">
                        @csrf
                        @method('PUT')
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="input-label">Category Name <span class="text-danger">*</span></label>
                                    <input type="text" name="name" class="form-control" value="{{old('name', $category->name)}}" required>
                                    @error('name')
                                        <div class="text-danger">{{$message}}</div>
                                    @enderror
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="input-label">Sort Order</label>
                                    <input type="number" name="sort_order" class="form-control" value="{{old('sort_order', $category->sort_order)}}" min="0">
                                    @error('sort_order')
                                        <div class="text-danger">{{$message}}</div>
                                    @enderror
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="input-label">وصف القسم</label>
                            <textarea name="description" class="form-control" rows="4" placeholder="وصف مختصر عن القسم">{{old('description', $category->description)}}</textarea>
                            @error('description')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">صورة القسم</label>
                            
                            @if($category->image)
                                <div class="mb-2">
                                    <img src="{{asset('storage/' . $category->image)}}" class="img-thumbnail" style="max-width: 200px;">
                                    <p class="text-muted small">الصورة الحالية</p>
                                </div>
                            @endif
                            
                            <div class="custom-file">
                                <input type="file" name="image" class="custom-file-input" id="imageUpload" accept="image/*">
                                <label class="custom-file-label" for="imageUpload">اختر صورة جديدة (اختياري)</label>
                            </div>
                            @error('image')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                            <div id="imagePreview" class="mt-2" style="display: none;">
                                <img id="previewImg" src="" class="img-thumbnail" style="max-width: 200px;">
                                <p class="text-muted small">معاينة الصورة الجديدة</p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="input-label">عنوان SEO</label>
                            <input type="text" name="meta_title" class="form-control" value="{{old('meta_title', $category->meta_title)}}" placeholder="عنوان الصفحة في محركات البحث">
                            @error('meta_title')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">وصف SEO</label>
                            <textarea name="meta_description" class="form-control" rows="3" placeholder="وصف الصفحة في محركات البحث">{{old('meta_description', $category->meta_description)}}</textarea>
                            @error('meta_description')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <div class="custom-control custom-checkbox">
                                <input type="checkbox" name="is_active" class="custom-control-input" id="isActive" value="1" {{old('is_active', $category->is_active) ? 'checked' : ''}}>
                                <label class="custom-control-label" for="isActive">نشط</label>
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
                    <h5 class="card-title">معلومات إضافية</h5>
                </div>
                <div class="card-body">
                    <div class="list-group list-group-flush">
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>عدد المقالات:</span>
                            <span class="badge badge-soft-info">{{$category->posts_count}}</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>تاريخ الإنشاء:</span>
                            <span>{{$category->created_at->format('Y-m-d H:i')}}</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>آخر تحديث:</span>
                            <span>{{$category->updated_at->format('Y-m-d H:i')}}</span>
                        </div>
                        <div class="list-group-item d-flex justify-content-between align-items-center">
                            <span>الرابط:</span>
                            <small class="text-muted">{{$category->slug}}</small>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card mt-3">
                <div class="card-header">
                    <h5 class="card-title">إجراءات سريعة</h5>
                </div>
                <div class="card-body">
                    <a href="{{route('admin.blog.categories.show', $category)}}" class="btn btn-outline-info btn-block mb-2">
                        <i class="tio-visible"></i> عرض التفاصيل
                    </a>
                    <button type="button" class="btn btn-outline-danger btn-block" onclick="deleteCategory({{$category->id}})">
                        <i class="tio-delete"></i> حذف القسم
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">تأكيد الحذف</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                هل أنت متأكد من حذف هذا القسم؟ سيتم حذف جميع المقالات المرتبطة به أيضاً.
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

    function deleteCategory(id) {
        $('#deleteForm').attr('action', '{{url("/")}}/admin/blog/categories/' + id);
        $('#deleteModal').modal('show');
    }
</script>
@endpush

