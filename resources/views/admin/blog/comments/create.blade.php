@extends('layouts.admin.app')

@section('title', 'Add New Comment')

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
            <span>Add New Comment</span>
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
                    <form action="{{route('admin.blog.comments.store')}}" method="post">
                        @csrf
                        
                        <div class="form-group">
                            <label class="input-label">المقال <span class="text-danger">*</span></label>
                            <select name="post_id" class="form-control" required>
                                <option value="">اختر المقال</option>
                                @foreach(\App\Models\BlogPost::published()->get() as $post)
                                    <option value="{{$post->id}}" {{old('post_id') == $post->id ? 'selected' : ''}}>
                                        {{$post->title}}
                                    </option>
                                @endforeach
                            </select>
                            @error('post_id')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">اسم المعلق <span class="text-danger">*</span></label>
                            <input type="text" name="name" class="form-control" value="{{old('name')}}" required>
                            @error('name')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">البريد الإلكتروني <span class="text-danger">*</span></label>
                            <input type="email" name="email" class="form-control" value="{{old('email')}}" required>
                            @error('email')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">الموقع الإلكتروني</label>
                            <input type="url" name="website" class="form-control" value="{{old('website')}}" placeholder="https://example.com">
                            @error('website')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="form-group">
                            <label class="input-label">التعليق <span class="text-danger">*</span></label>
                            <textarea name="comment" class="form-control" rows="6" required>{{old('comment')}}</textarea>
                            @error('comment')
                                <div class="text-danger">{{$message}}</div>
                            @enderror
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" name="is_approved" class="custom-control-input" id="isApproved" value="1" {{old('is_approved') ? 'checked' : ''}}>
                                        <label class="custom-control-label" for="isApproved">معتمد</label>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" name="is_spam" class="custom-control-input" id="isSpam" value="1" {{old('is_spam') ? 'checked' : ''}}>
                                        <label class="custom-control-label" for="isSpam">Spam</label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="btn--container justify-content-end">
                            <button type="submit" class="btn btn-primary">
                                <i class="tio-save"></i> حفظ التعليق
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="card-title">ملاحظات</h5>
                </div>
                <div class="card-body">
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="tio-info text-info"></i>
                            يمكنك إضافة تعليقات نيابة عن المستخدمين
                        </li>
                        <li class="mb-2">
                            <i class="tio-checkmark-circle text-success"></i>
                            حدد "معتمد" لإظهار التعليق مباشرة
                        </li>
                        <li class="mb-2">
                            <i class="tio-flag text-warning"></i>
                            حدد "Spam" لحجب التعليق
                        </li>
                        <li class="mb-2">
                            <i class="tio-document text-primary"></i>
                            اختر المقال المناسب للتعليق
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

