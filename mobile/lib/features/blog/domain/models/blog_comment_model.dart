import 'package:sixam_mart/features/blog/domain/models/blog_post_model.dart';

class BlogCommentModel {
  int? id;
  int? postId;
  BlogPostModel? post;
  String? name;
  String? email;
  String? comment;
  bool? isApproved;
  bool? isSpam;
  String? ipAddress;
  String? createdAt;
  String? updatedAt;

  BlogCommentModel({
    this.id,
    this.postId,
    this.post,
    this.name,
    this.email,
    this.comment,
    this.isApproved,
    this.isSpam,
    this.ipAddress,
    this.createdAt,
    this.updatedAt,
  });

  BlogCommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    post = json['post'] != null ? BlogPostModel.fromJson(json['post']) : null;
    name = json['name'];
    email = json['email'];
    comment = json['comment'];
    isApproved = json['is_approved'];
    isSpam = json['is_spam'];
    ipAddress = json['ip_address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['post_id'] = postId;
    if (post != null) {
      data['post'] = post!.toJson();
    }
    data['name'] = name;
    data['email'] = email;
    data['comment'] = comment;
    data['is_approved'] = isApproved;
    data['is_spam'] = isSpam;
    data['ip_address'] = ipAddress;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
