@extends('layouts.admin.app')

@section('title', 'Category Details')

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
            <span>Category Details: {{$category->name}}</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.categories.index')}}" class="btn btn-secondary">
                <i class="tio-arrow-backward"></i> Back to List
            </a>
            <a href="{{route('admin.blog.categories.edit', $category)}}" class="btn btn-primary">
                <i class="tio-edit"></i> Edit
            </a>
        </div>
    </div>
    <!-- End Page Header -->

    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">معلومات القسم</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                            @if($category->image)
                                @if(str_starts_with($category->image, 'http'))
                                    <img src="{{$category->image}}" class="img-fluid rounded" alt="{{$category->name}}">
                                @else
                                    <img src="{{asset('storage/' . $category->image)}}" class="img-fluid rounded" alt="{{$category->name}}">
                                @endif
                            @else
                                <div class="bg-light d-flex align-items-center justify-content-center rounded" style="height: 200px;">
                                    <i class="tio-image text-muted" style="font-size: 3rem;"></i>
                                </div>
                            @endif
                        </div>
                        <div class="col-md-8">
                            <table class="table table-borderless">
                                <tr>
                                    <td><strong>اسم القسم:</strong></td>
                                    <td>{{$category->name}}</td>
                                </tr>
                                <tr>
                                    <td><strong>الرابط:</strong></td>
                                    <td><code>{{$category->slug}}</code></td>
                                </tr>
                                <tr>
                                    <td><strong>الحالة:</strong></td>
                                    <td>
                                        @if($category->is_active)
                                            <span class="badge badge-soft-success">نشط</span>
                                        @else
                                            <span class="badge badge-soft-danger">غير نشط</span>
                                        @endif
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>ترتيب العرض:</strong></td>
                                    <td><span class="badge badge-soft-secondary">{{$category->sort_order}}</span></td>
                                </tr>
                                <tr>
                                    <td><strong>تاريخ الإنشاء:</strong></td>
                                    <td>{{$category->created_at->format('Y-m-d H:i')}}</td>
                                </tr>
                                <tr>
                                    <td><strong>آخر تحديث:</strong></td>
                                    <td>{{$category->updated_at->format('Y-m-d H:i')}}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    
                    @if($category->description)
                        <div class="mt-3">
                            <h6>الوصف:</h6>
                            <p class="text-muted">{{$category->description}}</p>
                        </div>
                    @endif

                    @if($category->meta_title || $category->meta_description)
                        <div class="mt-3">
                            <h6>معلومات SEO:</h6>
                            @if($category->meta_title)
                                <p><strong>عنوان SEO:</strong> {{$category->meta_title}}</p>
                            @endif
                            @if($category->meta_description)
                                <p><strong>وصف SEO:</strong> {{$category->meta_description}}</p>
                            @endif
                        </div>
                    @endif
                </div>
            </div>

            <!-- مقالات القسم -->
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">
                        مقالات القسم ({{$category->posts->count()}})
                        <a href="{{route('admin.blog.posts.create')}}?category_id={{$category->id}}" class="btn btn-sm btn-primary float-right">
                            <i class="tio-add"></i> إضافة مقال جديد
                        </a>
                    </h5>
                </div>
                <div class="card-body">
                    @if($category->posts->count() > 0)
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>العنوان</th>
                                        <th>الحالة</th>
                                        <th>التاريخ</th>
                                        <th>المشاهدات</th>
                                        <th>الإجراءات</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($category->posts as $post)
                                        <tr>
                                            <td>
                                                <div class="media align-items-center">
                                                    @if($post->featured_image)
                                                        <img src="{{asset('storage/' . $post->featured_image)}}" class="img--40 mr-2" alt="{{$post->title}}">
                                                    @endif
                                                    <div class="media-body">
                                                        <h6 class="mb-0">{{Str::limit($post->title, 50)}}</h6>
                                                        <small class="text-muted">{{Str::limit(strip_tags($post->excerpt), 80)}}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                @if($post->is_published)
                                                    <span class="badge badge-soft-success">منشور</span>
                                                @else
                                                    <span class="badge badge-soft-warning">مسودة</span>
                                                @endif
                                                @if($post->is_featured)
                                                    <span class="badge badge-soft-info">مميز</span>
                                                @endif
                                            </td>
                                            <td>
                                                @if($post->published_at)
                                                    {{$post->published_at->format('Y-m-d')}}
                                                @else
                                                    <span class="text-muted">لم ينشر بعد</span>
                                                @endif
                                            </td>
                                            <td>
                                                <span class="badge badge-soft-secondary">{{$post->views_count}}</span>
                                            </td>
                                            <td>
                                                <div class="btn--container">
                                                    <a href="{{route('admin.blog.posts.show', $post)}}" class="btn btn-sm btn-outline-primary" title="عرض">
                                                        <i class="tio-visible"></i>
                                                    </a>
                                                    <a href="{{route('admin.blog.posts.edit', $post)}}" class="btn btn-sm btn-outline-secondary" title="تعديل">
                                                        <i class="tio-edit"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    @else
                        <div class="text-center py-4">
                            <img src="{{asset('public/assets/admin/img/empty-state.png')}}" alt="لا توجد مقالات" style="width: 5rem;">
                            <p class="mt-2 text-muted">لا توجد مقالات في هذا القسم</p>
                            <a href="{{route('admin.blog.posts.create')}}?category_id={{$category->id}}" class="btn btn-primary">
                                إضافة أول مقال
                            </a>
                        </div>
                    @endif
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">إحصائيات القسم</h5>
                </div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col-6">
                            <div class="border rounded p-3">
                                <h4 class="text-primary">{{$category->posts->count()}}</h4>
                                <p class="mb-0 text-muted">مقال</p>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="border rounded p-3">
                                <h4 class="text-success">{{$category->posts->where('is_published', true)->count()}}</h4>
                                <p class="mb-0 text-muted">منشور</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="card mt-3">
                <div class="card-header">
                    <h5 class="card-title">إجراءات سريعة</h5>
                </div>
                <div class="card-body">
                    <a href="{{route('admin.blog.categories.edit', $category)}}" class="btn btn-outline-primary btn-block mb-2">
                        <i class="tio-edit"></i> تعديل القسم
                    </a>
                    <a href="{{route('admin.blog.posts.create')}}?category_id={{$category->id}}" class="btn btn-outline-success btn-block mb-2">
                        <i class="tio-add"></i> إضافة مقال جديد
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
    function deleteCategory(id) {
        $('#deleteForm').attr('action', '{{url("/")}}/admin/blog/categories/' + id);
        $('#deleteModal').modal('show');
    }
</script>
@endpush

