import 'package:sixam_mart/features/blog/domain/models/blog_comment_model.dart';
import 'package:sixam_mart/features/blog/domain/services/blog_service_interface.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:get/get.dart';

class BlogService implements BlogServiceInterface {
  final ApiClient apiClient;
  
  BlogService({required this.apiClient});

  @override
  Future<Response> getBlogCategories() async {
    print('BlogService: Making API call to /api/v1/blog/categories');
    Response response = await apiClient.getData('/api/v1/blog/categories');
    print('BlogService: Categories API response status: ${response.statusCode}');
    return response;
  }

  @override
  Future<Response> getBlogPosts({int? page, int? categoryId}) async {
    String url = '/api/v1/blog/posts';
    Map<String, dynamic> params = {};
    
    if (page != null) {
      params['page'] = page;
    }
    if (categoryId != null) {
      params['category_id'] = categoryId;
    }
    
    print('BlogService: Making API call to $url with params: $params');
    Response response = await apiClient.getData(url, query: params);
    print('BlogService: API response status: ${response.statusCode}');
    return response;
  }

  @override
  Future<Response> getBlogPost(int postId) async {
    return await apiClient.getData('/api/v1/blog/posts/$postId');
  }

  @override
  Future<Response> getBlogComments(int postId) async {
    return await apiClient.getData('/api/v1/blog/posts/$postId/comments');
  }

  @override
  Future<Response> createBlogComment(BlogCommentModel comment) async {
    return await apiClient.postData('/api/v1/blog/comments', comment.toJson());
  }
}
