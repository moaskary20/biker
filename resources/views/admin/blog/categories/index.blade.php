@extends('layouts.admin.app')

@section('title', 'Blog Categories Management')

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
            <span>Blog Categories Management</span>
        </h1>
        <div class="page-header-actions">
            <a href="{{route('admin.blog.categories.create')}}" class="btn btn-primary">
                <i class="tio-add"></i> Add New Category
            </a>
        </div>
    </div>
    <!-- End Page Header -->

    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header border-0">
                    <div class="search--button-wrapper">
                        <h5 class="card-title">
                            <span class="card-header-icon">
                                <i class="tio-category"></i>
                            </span>
                            <span>Categories List ({{$categories->count()}})</span>
                        </h5>
                        <form class="search-form">
                            <div class="input-group input--group">
                                <input type="search" name="search" class="form-control" placeholder="Search in categories..." value="{{request('search')}}">
                                <button type="submit" class="btn btn--secondary">
                                    <i class="tio-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="card-body p-0">
                    @if($categories->count() > 0)
                        <div class="table-responsive">
                            <table class="table table-hover table-borderless table-thead-bordered table-nowrap table-align-middle">
                                <thead class="thead-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Image</th>
                                        <th>Category Name</th>
                                        <th>Description</th>
                                        <th>Posts Count</th>
                                        <th>Sort Order</th>
                                        <th>Status</th>
                                        <th>Created Date</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach($categories as $key => $category)
                                        <tr>
                                            <td>{{$categories->firstItem() + $key}}</td>
                                            <td>
                                                @if($category->image)
                                                    @if(str_starts_with($category->image, 'http'))
                                                        <img src="{{$category->image}}" class="img--40" alt="{{$category->name}}">
                                                    @else
                                                        <img src="http://192.168.1.44:8000/storage/{{$category->image}}" class="img--40" alt="{{$category->name}}">
                                                    @endif
                                                @else
                                                    <div class="img--40 bg-light d-flex align-items-center justify-content-center">
                                                        <i class="tio-image"></i>
                                                    </div>
                                                @endif
                                            </td>
                                            <td>
                                                <span class="d-block font-size-sm text-body">
                                                    {{$category->name}}
                                                </span>
                                                <small class="text-muted">{{$category->slug}}</small>
                                            </td>
                                            <td>
                                                <span class="d-block font-size-sm text-body">
                                                    {{Str::limit($category->description, 50)}}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge badge-soft-info">{{$category->posts_count}}</span>
                                            </td>
                                            <td>
                                                <span class="badge badge-soft-secondary">{{$category->sort_order}}</span>
                                            </td>
                                            <td>
                                                <label class="toggle-switch toggle-switch-sm ml-2">
                                                    <input type="checkbox" class="toggle-switch-input" 
                                                           {{$category->is_active ? 'checked' : ''}} 
                                                           onchange="toggleStatus({{$category->id}})">
                                                    <span class="toggle-switch-label">
                                                        <span class="toggle-switch-indicator"></span>
                                                    </span>
                                                </label>
                                            </td>
                                            <td>{{$category->created_at->format('Y-m-d')}}</td>
                                            <td>
                                                <div class="btn--container justify-content-center">
                                                    <a class="btn btn-sm btn-outline-primary" 
                                                       href="{{route('admin.blog.categories.show', $category)}}" 
                                                       title="View Details">
                                                        <i class="tio-visible"></i>
                                                    </a>
                                                    <a class="btn btn-sm btn-outline-secondary" 
                                                       href="{{route('admin.blog.categories.edit', $category)}}" 
                                                       title="Edit">
                                                        <i class="tio-edit"></i>
                                                    </a>
                                                    <button type="button" class="btn btn-sm btn-outline-danger" 
                                                            onclick="deleteCategory({{$category->id}})" 
                                                            title="Delete">
                                                        <i class="tio-delete"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        
                        @if($categories->hasPages())
                            <div class="card-footer border-0">
                                {{$categories->links()}}
                            </div>
                        @endif
                    @else
                        <div class="text-center p-4">
                            <img class="mb-3" src="{{asset('public/assets/admin/img/empty-state.png')}}" alt="Image Description" style="width: 7rem;">
                            <p class="mb-0">No categories found yet</p>
                            <a class="btn btn-primary mt-3" href="{{route('admin.blog.categories.create')}}">
                                Add New Category
                            </a>
                        </div>
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Pagination -->
@if($categories->hasPages())
<div class="row">
    <div class="col-12">
        <div class="d-flex justify-content-center">
            {{ $categories->links() }}
        </div>
    </div>
</div>
@endif

<!-- Delete Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                Are you sure you want to delete this category? All associated posts will also be deleted.
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
    function toggleStatus(id) {
        $.get('{{url("/")}}/admin/blog/categories/' + id + '/toggle-status', function(data) {
            toastr.success(data.message);
        });
    }

    function deleteCategory(id) {
        $('#deleteForm').attr('action', '{{url("/")}}/admin/blog/categories/' + id);
        $('#deleteModal').modal('show');
    }
</script>
@endpush

