import 'package:flutter/material.dart';
import 'package:sixam_mart/features/blog/domain/models/blog_comment_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:intl/intl.dart';

class BlogCommentItem extends StatelessWidget {
  final BlogCommentModel comment;

  const BlogCommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: Theme.of(context).disabledColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment Header
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    (comment.name ?? 'U')[0].toUpperCase(),
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: Dimensions.paddingSizeDefault),
              
              // Comment Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.name ?? 'Anonymous',
                      style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      comment.createdAt != null
                          ? DateFormat('MMM dd, yyyy at HH:mm').format(DateTime.parse(comment.createdAt!))
                          : 'No date',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status Badge
              if (comment.isApproved == true)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeExtraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  ),
                  child: Text(
                    'Approved',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Colors.green,
                    ),
                  ),
                )
              else
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
                    'Pending',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeExtraSmall,
                      color: Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: Dimensions.paddingSizeDefault),
          
          // Comment Content
          Text(
            comment.comment ?? '',
            style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
