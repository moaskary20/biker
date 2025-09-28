import 'package:sixam_mart/features/blog/domain/models/blog_category_model.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_post_model.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_comment_model.dart';
import 'package:sixam_mart/features/blog/domain/repositories/blog_repository_interface.dart';
import 'package:sixam_mart/features/blog/domain/services/blog_service_interface.dart';
import 'package:get/get.dart';

class BlogRepository implements BlogRepositoryInterface {
  final BlogServiceInterface blogServiceInterface;
  
  BlogRepository({required this.blogServiceInterface});

  @override
  Future<List<BlogCategoryModel>?> getBlogCategories() async {
    try {
      Response response = await blogServiceInterface.getBlogCategories();
      if (response.statusCode == 200 && response.body['success'] == true) {
        List<BlogCategoryModel> categories = [];
        if (response.body['categories'] != null) {
          for (var category in response.body['categories']) {
            categories.add(BlogCategoryModel.fromJson(category));
          }
        }
        return categories;
      }
    } catch (e) {
      print('Error getting blog categories: $e');
    }
    return null;
  }

  @override
  Future<List<BlogPostModel>?> getBlogPosts({int? page, int? categoryId}) async {
    try {
      print('BlogRepository: Fetching blog posts from API...');
      Response response = await blogServiceInterface.getBlogPosts(page: page, categoryId: categoryId);
      print('BlogRepository: API Response Status: ${response.statusCode}');
      print('BlogRepository: API Response Body: ${response.body}');
      
      if (response.statusCode == 200 && response.body['success'] == true) {
        List<BlogPostModel> posts = [];
        if (response.body['posts'] != null) {
          print('BlogRepository: Found ${response.body['posts'].length} posts');
          for (var post in response.body['posts']) {
            posts.add(BlogPostModel.fromJson(post));
          }
        }
        return posts;
      } else {
        print('BlogRepository: API call failed - Status: ${response.statusCode}, Success: ${response.body['success']}');
      }
    } catch (e) {
      print('Error getting blog posts: $e');
    }
    return null;
  }

  @override
  Future<BlogPostModel?> getBlogPost(int postId) async {
    try {
      Response response = await blogServiceInterface.getBlogPost(postId);
      if (response.statusCode == 200 && response.body['success'] == true) {
        return BlogPostModel.fromJson(response.body['post']);
      }
    } catch (e) {
      print('Error getting blog post: $e');
    }
    return null;
  }

  @override
  Future<List<BlogCommentModel>?> getBlogComments(int postId) async {
    try {
      Response response = await blogServiceInterface.getBlogComments(postId);
      if (response.statusCode == 200 && response.body['success'] == true) {
        List<BlogCommentModel> comments = [];
        if (response.body['comments'] != null) {
          for (var comment in response.body['comments']) {
            comments.add(BlogCommentModel.fromJson(comment));
          }
        }
        return comments;
      }
    } catch (e) {
      print('Error getting blog comments: $e');
    }
    return null;
  }

  @override
  Future<bool> createBlogComment(BlogCommentModel comment) async {
    try {
      Response response = await blogServiceInterface.createBlogComment(comment);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating blog comment: $e');
    }
    return false;
  }
}
