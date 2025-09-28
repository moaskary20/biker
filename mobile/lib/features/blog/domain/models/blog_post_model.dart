import 'package:sixam_mart/features/blog/domain/models/blog_category_model.dart';

class BlogPostModel {
  int? id;
  String? title;
  String? slug;
  String? excerpt;
  String? content;
  int? categoryId;
  BlogCategoryModel? category;
  String? image;
  String? imageFullUrl;
  String? metaTitle;
  String? metaDescription;
  List<String>? tags;
  bool? isPublished;
  bool? isFeatured;
  int? viewsCount;
  int? likesCount;
  int? commentsCount;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  BlogPostModel({
    this.id,
    this.title,
    this.slug,
    this.excerpt,
    this.content,
    this.categoryId,
    this.category,
    this.image,
    this.imageFullUrl,
    this.metaTitle,
    this.metaDescription,
    this.tags,
    this.isPublished,
    this.isFeatured,
    this.viewsCount,
    this.likesCount,
    this.commentsCount,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  BlogPostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    excerpt = json['excerpt'];
    content = json['content'];
    categoryId = json['category_id'];
    category = json['category'] != null ? BlogCategoryModel.fromJson(json['category']) : null;
    image = json['featured_image'] ?? json['image'];
    imageFullUrl = json['image_full_url'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : null;
    isPublished = json['is_published'];
    isFeatured = json['is_featured'];
    viewsCount = json['views_count'];
    likesCount = json['likes_count'];
    commentsCount = json['comments_count'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['excerpt'] = excerpt;
    data['content'] = content;
    data['category_id'] = categoryId;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['image'] = image;
    data['image_full_url'] = imageFullUrl;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['tags'] = tags;
    data['is_published'] = isPublished;
    data['is_featured'] = isFeatured;
    data['views_count'] = viewsCount;
    data['likes_count'] = likesCount;
    data['comments_count'] = commentsCount;
    data['published_at'] = publishedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
