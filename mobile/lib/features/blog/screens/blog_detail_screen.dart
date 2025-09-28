import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/blog/controllers/blog_controller.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_post_model.dart';
import 'package:sixam_mart/features/blog/widgets/blog_comment_form.dart';
import 'package:sixam_mart/features/blog/widgets/blog_comment_item.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:html/parser.dart' as html_parser;

class BlogDetailScreen extends StatefulWidget {
  final BlogPostModel post;
  
  const BlogDetailScreen({super.key, required this.post});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<BlogController>().getBlogComments(widget.post.id!);
  }

  String _parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Blog Post',
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Image
                if (widget.post.image != null)
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.post.image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      if (widget.post.category != null)
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
                            widget.post.category!.name!,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),

                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      // Post Title
                      Text(
                        widget.post.title ?? '',
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeExtraLarge,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      // Post Meta Info
                      Row(
                        children: [
                          Icon(
                            Icons.visibility,
                            size: 16,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            '${widget.post.viewsCount ?? 0} views',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            '${widget.post.likesCount ?? 0} likes',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Icon(
                            Icons.comment,
                            size: 16,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            '${widget.post.commentsCount ?? 0} comments',
                            style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      // Post Content
                      Text(
                        _parseHtmlString(widget.post.content ?? ''),
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // Tags
                      if (widget.post.tags != null && widget.post.tags!.isNotEmpty) ...[
                        Text(
                          'Tags:',
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Wrap(
                          spacing: Dimensions.paddingSizeSmall,
                          children: widget.post.tags!.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeExtraSmall,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ],

                      // Comments Section
                      Text(
                        'Comments (${widget.post.commentsCount ?? 0})',
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      // Comment Form
                      BlogCommentForm(
                        postId: widget.post.id!,
                        onSubmit: (comment) async {
                          bool success = await blogController.createBlogComment(comment);
                          if (success) {
                            Get.snackbar(
                              'Success',
                              'Comment submitted successfully',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } else {
                            Get.snackbar(
                              'Error',
                              'Failed to submit comment',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                      ),

                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      // Comments List
                      if (blogController.blogComments != null && blogController.blogComments!.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: blogController.blogComments!.length,
                          itemBuilder: (context, index) {
                            return BlogCommentItem(
                              comment: blogController.blogComments![index],
                            );
                          },
                        )
                      else
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                            child: Text(
                              'No comments yet',
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
