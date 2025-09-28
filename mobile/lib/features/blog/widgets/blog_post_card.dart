import 'package:flutter/material.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_post_model.dart';
import 'package:sixam_mart/features/blog/widgets/blog_image_widget.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:intl/intl.dart';

class BlogPostCard extends StatelessWidget {
  final BlogPostModel post;
  final VoidCallback onTap;

  const BlogPostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              imageUrl: post.image,
              imageFullUrl: post.imageFullUrl,
              width: double.infinity,
              height: 180,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radiusDefault),
                topRight: Radius.circular(Dimensions.radiusDefault),
              ),
              isCategory: false,
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Featured Badge
                  Row(
                    children: [
                      if (post.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text(
                            post.category!.name!,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      const Spacer(),
                      if (post.isFeatured == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
                          child: Text(
                            'Featured',
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // Post Title
                  Text(
                    post.title ?? '',
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  // Post Excerpt
                  if (post.excerpt != null)
                    Text(
                      post.excerpt!,
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).disabledColor,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // Post Meta Info
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        post.publishedAt != null
                            ? DateFormat('MMM dd, yyyy').format(DateTime.parse(post.publishedAt!))
                            : 'No date',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        '${post.viewsCount ?? 0}',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Icon(
                        Icons.comment,
                        size: 16,
                        color: Theme.of(context).disabledColor,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        '${post.commentsCount ?? 0}',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
