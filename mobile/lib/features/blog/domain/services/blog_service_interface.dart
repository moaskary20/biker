import 'package:sixam_mart/features/blog/domain/models/blog_comment_model.dart';
import 'package:get/get.dart';

abstract class BlogServiceInterface {
  Future<Response> getBlogCategories();
  Future<Response> getBlogPosts({int? page, int? categoryId});
  Future<Response> getBlogPost(int postId);
  Future<Response> getBlogComments(int postId);
  Future<Response> createBlogComment(BlogCommentModel comment);
}
