import 'package:sixam_mart/features/blog/domain/models/blog_category_model.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_post_model.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_comment_model.dart';

abstract class BlogRepositoryInterface {
  Future<List<BlogCategoryModel>?> getBlogCategories();
  Future<List<BlogPostModel>?> getBlogPosts({int? page, int? categoryId});
  Future<BlogPostModel?> getBlogPost(int postId);
  Future<List<BlogCommentModel>?> getBlogComments(int postId);
  Future<bool> createBlogComment(BlogCommentModel comment);
}
