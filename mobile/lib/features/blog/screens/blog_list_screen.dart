import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/blog/controllers/blog_controller.dart';
import 'package:sixam_mart/features/blog/widgets/blog_post_card.dart';
import 'package:sixam_mart/features/blog/widgets/blog_category_chips.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print('BlogListScreen: Initializing...');
    
    try {
      if (Get.isRegistered<BlogController>()) {
        print('BlogListScreen: BlogController is registered, loading data...');
        // Use Future.microtask to avoid setState during build
        Future.microtask(() {
          Get.find<BlogController>().getBlogCategories();
          Get.find<BlogController>().getBlogPosts(reload: true);
        });
      } else {
        print('BlogListScreen: BlogController is NOT registered');
      }
    } catch (e) {
      print('BlogListScreen: Error in initState: $e');
    }
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
        if (Get.find<BlogController>().hasNextPage && !Get.find<BlogController>().isLoading) {
          Get.find<BlogController>().getBlogPosts();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Blog',
          style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: GetBuilder<BlogController>(
        builder: (blogController) {
          return RefreshIndicator(
            onRefresh: () async {
              await blogController.getBlogPosts(reload: true);
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Section
                  if (blogController.blogCategories != null && blogController.blogCategories!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: Theme.of(context).textTheme.bodyLarge!.color,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          BlogCategoryChips(
                            categories: blogController.blogCategories!,
                            selectedCategoryId: blogController.selectedCategoryId,
                            onCategorySelected: (categoryId) {
                              blogController.setSelectedCategory(categoryId);
                            },
                          ),
                        ],
                      ),
                    ),

                  // Posts Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latest Posts',
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        
                        // Posts List
                        if (blogController.blogPosts != null && blogController.blogPosts!.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: blogController.blogPosts!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                child: BlogPostCard(
                                  post: blogController.blogPosts![index],
                                  onTap: () {
                                    Get.toNamed('/blog-detail', arguments: blogController.blogPosts![index]);
                                  },
                                ),
                              );
                            },
                          )
                        else if (!blogController.isLoading)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 64,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  Text(
                                    'No posts found',
                                    style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        // Loading indicator
                        if (blogController.isLoading)
                          const Padding(
                            padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
