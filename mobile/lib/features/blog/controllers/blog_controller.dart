import 'package:sixam_mart/features/blog/domain/models/blog_category_model.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_post_model.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_comment_model.dart';
import 'package:sixam_mart/features/blog/domain/repositories/blog_repository_interface.dart';
import 'package:get/get.dart';

class BlogController extends GetxController implements GetxService {
  final BlogRepositoryInterface blogRepositoryInterface;

  BlogController({required this.blogRepositoryInterface});

  List<BlogCategoryModel>? _blogCategories;
  List<BlogPostModel>? _blogPosts;
  BlogPostModel? _selectedPost;
  List<BlogCommentModel>? _blogComments;
  bool _isLoading = false;
  int _currentPage = 1;
  int? _selectedCategoryId;
  bool _hasNextPage = true;

  List<BlogCategoryModel>? get blogCategories => _blogCategories;
  List<BlogPostModel>? get blogPosts => _blogPosts;
  BlogPostModel? get selectedPost => _selectedPost;
  List<BlogCommentModel>? get blogComments => _blogComments;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int? get selectedCategoryId => _selectedCategoryId;
  bool get hasNextPage => _hasNextPage;

  Future<void> getBlogCategories() async {
    _isLoading = true;
    update();
    
    try {
      _blogCategories = await blogRepositoryInterface.getBlogCategories();
    } catch (e) {
      print('Error loading blog categories: $e');
    }
    
    _isLoading = false;
    update();
  }

  Future<void> getBlogPosts({bool reload = false, int? categoryId}) async {
    if (reload) {
      _currentPage = 1;
      _blogPosts = [];
      _hasNextPage = true;
    }
    
    if (categoryId != null) {
      _selectedCategoryId = categoryId;
    }
    
    _isLoading = true;
    update();
    
    try {
      print('BlogController: Fetching blog posts...');
      List<BlogPostModel>? newPosts = await blogRepositoryInterface.getBlogPosts(
        page: _currentPage,
        categoryId: _selectedCategoryId,
      );
      
      print('BlogController: Received ${newPosts?.length ?? 0} posts');
      
      if (newPosts != null) {
        if (_blogPosts == null) {
          _blogPosts = newPosts;
        } else {
          _blogPosts!.addAll(newPosts);
        }
        
        if (newPosts.length < 10) { // Assuming 10 posts per page
          _hasNextPage = false;
        }
        
        _currentPage++;
        print('BlogController: Total posts now: ${_blogPosts?.length ?? 0}');
      } else {
        print('BlogController: No posts received');
      }
    } catch (e) {
      print('Error loading blog posts: $e');
    }
    
    _isLoading = false;
    update();
  }

  Future<void> getBlogPost(int postId) async {
    _isLoading = true;
    update();
    
    try {
      _selectedPost = await blogRepositoryInterface.getBlogPost(postId);
    } catch (e) {
      print('Error loading blog post: $e');
    }
    
    _isLoading = false;
    update();
  }

  Future<void> getBlogComments(int postId) async {
    try {
      _blogComments = await blogRepositoryInterface.getBlogComments(postId);
      update();
    } catch (e) {
      print('Error loading blog comments: $e');
    }
  }

  Future<bool> createBlogComment(BlogCommentModel comment) async {
    try {
      bool success = await blogRepositoryInterface.createBlogComment(comment);
      if (success) {
        // Refresh comments after creating new one
        if (comment.postId != null) {
          await getBlogComments(comment.postId!);
        }
      }
      return success;
    } catch (e) {
      print('Error creating blog comment: $e');
      return false;
    }
  }

  void setSelectedCategory(int? categoryId) {
    _selectedCategoryId = categoryId;
    getBlogPosts(reload: true, categoryId: categoryId);
  }

  void clearSelectedPost() {
    _selectedPost = null;
    _blogComments = null;
    update();
  }
}
