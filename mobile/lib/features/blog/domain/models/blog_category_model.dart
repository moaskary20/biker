import 'package:sixam_mart/features/blog/domain/models/blog_post_model.dart';

class BlogCategoryModel {
  int? id;
  String? name;
  String? slug;
  String? description;
  String? image;
  String? metaTitle;
  String? metaDescription;
  bool? isActive;
  int? sortOrder;
  String? createdAt;
  String? updatedAt;
  List<BlogPostModel>? posts;

  BlogCategoryModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.image,
    this.metaTitle,
    this.metaDescription,
    this.isActive,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
    this.posts,
  });

  BlogCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    image = json['image'];
    metaTitle = json['meta_title'];
    metaDescription = json['meta_description'];
    isActive = json['is_active'];
    sortOrder = json['sort_order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['posts'] != null) {
      posts = <BlogPostModel>[];
      json['posts'].forEach((v) {
        posts!.add(BlogPostModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['image'] = image;
    data['meta_title'] = metaTitle;
    data['meta_description'] = metaDescription;
    data['is_active'] = isActive;
    data['sort_order'] = sortOrder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
