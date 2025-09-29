import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/blog/controllers/blog_controller.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_post_model.dart';
import 'package:sixam_mart/features/blog/screens/blog_list_screen.dart';
import 'package:sixam_mart/features/blog/widgets/blog_image_widget.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:html/parser.dart' as html_parser;

class BlogGridWidget extends StatelessWidget {
  const BlogGridWidget({super.key});

  String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // Check if BlogController is registered
    if (!Get.isRegistered<BlogController>()) {
      print('BlogGridWidget: BlogController is NOT registered');
      return const SizedBox();
    }
    
    return GetBuilder<BlogController>(
      builder: (blogController) {
        print('BlogGridWidget: BlogController posts count: ${blogController.blogPosts?.length ?? 0}');
        
        // Show loading or empty state
        if (blogController.blogPosts == null || blogController.blogPosts!.isEmpty) {
          return const SizedBox();
        }

        // Get only first 4 posts for home screen
        List<BlogPostModel> featuredPosts = blogController.blogPosts!.take(4).toList();

        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Blog',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.to(() => const BlogListScreen()),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              // Blog Posts Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: Dimensions.paddingSizeSmall,
                    mainAxisSpacing: Dimensions.paddingSizeSmall,
                  ),
                  itemCount: featuredPosts.length,
                  itemBuilder: (context, index) {
                    final post = featuredPosts[index];
                    return InkWell(
                      onTap: () {
                        Get.toNamed('/blog-detail', arguments: post);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Post Image
            BlogImageWidget(
              imageUrl: post.imageFullUrl ?? post.image,
              imageFullUrl: post.imageFullUrl,
              width: double.infinity,
              height: 120,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusDefault),
                topRight: Radius.circular(Dimensions.radiusDefault),
              ),
              isCategory: false,
            ),

                            // Post Content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Category
                                    if (post.category != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Dimensions.paddingSizeExtraSmall,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        ),
                                        child: Text(
                                          post.category!.name!,
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    // Title
                                    Text(
                                      post.title ?? '',
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).textTheme.bodyLarge!.color,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const Spacer(),

                                    // Meta Info
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.visibility,
                                          size: 12,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${post.viewsCount ?? 0}',
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context).disabledColor,
                                          ),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.comment,
                                          size: 12,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${post.commentsCount ?? 0}',
                                          style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context).disabledColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
